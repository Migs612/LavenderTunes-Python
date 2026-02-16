from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi import Request
import uvicorn
import mysql.connector
from mysql.connector import Error
from pathlib import Path
from typing import List, Dict, Any
import os
from dotenv import load_dotenv
from decimal import Decimal
import requests
import time

load_dotenv()

app = FastAPI(title="LavenderTunes API")

app.mount("/static", StaticFiles(directory="app/static"), name="static")

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "user": os.getenv("DB_USER", "ManuelPython"),
    "password": os.getenv("DB_PASSWORD", "LavenderTunes"),
    "database": os.getenv("DB_NAME", "lavendertunes"),
}


def get_db_connection():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"Error conectando a MySQL: {e}")
        raise HTTPException(status_code=500, detail=f"Error de conexión a base de datos: {str(e)}")


SPOTIFY_TOKEN: str | None = None
SPOTIFY_TOKEN_EXPIRES_AT: float = 0


def get_spotify_token() -> str:
    global SPOTIFY_TOKEN, SPOTIFY_TOKEN_EXPIRES_AT

    if SPOTIFY_TOKEN and time.time() < SPOTIFY_TOKEN_EXPIRES_AT:
        return SPOTIFY_TOKEN

    client_id = os.getenv("SPOTIFY_CLIENT_ID") or os.getenv("SPOTIPY_CLIENT_ID")
    client_secret = os.getenv("SPOTIFY_CLIENT_SECRET") or os.getenv("SPOTIPY_CLIENT_SECRET")

    def _clean(v: str | None) -> str | None:
        if not v:
            return None
        v = v.strip()
        if (v.startswith('"') and v.endswith('"')) or (v.startswith("'") and v.endswith("'")):
            return v[1:-1]
        return v

    client_id = _clean(client_id)
    client_secret = _clean(client_secret)

    if not client_id or not client_secret:
        raise HTTPException(status_code=500, detail="Spotify credentials not configured in environment")

    token_url = "https://accounts.spotify.com/api/token"
    try:
        resp = requests.post(token_url, data={"grant_type": "client_credentials"}, auth=(client_id, client_secret), timeout=10)
    except requests.RequestException as e:
        raise HTTPException(status_code=502, detail=f"Error contacting Spotify auth: {str(e)}")

    if resp.status_code != 200:
        raise HTTPException(status_code=502, detail=f"Spotify auth failed: {resp.status_code} {resp.text}")

    data = resp.json()
    token = data.get("access_token")
    expires_in = data.get("expires_in", 3600)

    if not token:
        raise HTTPException(status_code=502, detail="Spotify did not return access token")

    SPOTIFY_TOKEN = token
    SPOTIFY_TOKEN_EXPIRES_AT = time.time() + int(expires_in) - 30
    return SPOTIFY_TOKEN


@app.get("/api/spotify/search")
async def spotify_search(q: str):
    token = get_spotify_token()
    headers = {"Authorization": f"Bearer {token}"}
    params = {"q": q, "type": "album", "limit": 12}

    try:
        resp = requests.get("https://api.spotify.com/v1/search", headers=headers, params=params, timeout=10)
    except requests.RequestException as e:
        raise HTTPException(status_code=502, detail=f"Error contacting Spotify API: {str(e)}")

    if resp.status_code != 200:
        raise HTTPException(status_code=502, detail=f"Spotify API error: {resp.status_code} {resp.text}")

    data = resp.json()
    albums = data.get("albums", {}).get("items", [])

    simplified = []
    for a in albums:
        artists = ", ".join([artist.get("name", "") for artist in a.get("artists", [])])
        images = a.get("images", [])
        image_url = images[0]["url"] if images else None
        simplified.append({
            "id": a.get("id"),
            "name": a.get("name"),
            "artists": artists,
            "release_date": a.get("release_date"),
            "total_tracks": a.get("total_tracks"),
            "image_url": image_url,
            "spotify_url": a.get("external_urls", {}).get("spotify"),
        })

    return simplified


@app.post("/api/discos/from_spotify")
async def create_disco_from_spotify(payload: dict):
    spotify_id = payload.get("spotify_id")
    name = payload.get("name")
    artists = payload.get("artists")
    release_date = payload.get("release_date")
    image_url = payload.get("image_url")
    price = payload.get("price")
    stock = payload.get("stock", 1)

    if not spotify_id or not name or price is None:
        raise HTTPException(status_code=400, detail="spotify_id, name and price are required")

    if not isinstance(stock, int) or stock < 1:
        raise HTTPException(status_code=400, detail="stock must be a positive integer")

    year = None
    try:
        if release_date:
            year = int(str(release_date).split('-')[0])
    except Exception:
        year = None

    connection = None
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        insert_query = (
            "INSERT INTO discos (nombre, artista, album, genero, anio_lanzamiento, "
            "sello_discografico, codigo_barras, precio, stock, imagen_url) "
            "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        genero = "Desconocido"
        sello = None
        codigo_barras = spotify_id

        cursor.execute(insert_query, (
            name, artists, name, genero, year, sello, codigo_barras, price, stock, image_url
        ))
        connection.commit()
        new_id = cursor.lastrowid
        cursor.close()

        return {"success": True, "id": new_id, "stock": stock}

    except mysql.connector.IntegrityError as e:
        raise HTTPException(status_code=409, detail="El disco ya existe en el catálogo")

    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error al insertar disco: {str(e)}")

    finally:
        if connection and connection.is_connected():
            connection.close()


@app.get("/", response_class=HTMLResponse)
async def read_root():
    html_path = Path("app/templates/pages/index.html")
    if html_path.exists():
        return html_path.read_text(encoding="utf-8")
    raise HTTPException(status_code=404, detail="Página no encontrada")


@app.get("/api/discos", response_model=List[Dict[str, Any]])
async def get_discos():
    connection = None
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        
        query = """
            SELECT id, nombre, artista, album, genero, anio_lanzamiento, 
                   sello_discografico, codigo_barras, precio, stock, 
                   imagen_url, fecha_agregado
            FROM discos
            ORDER BY nombre
        """
        
        cursor.execute(query)
        discos = cursor.fetchall()
        
        for disco in discos:
            if isinstance(disco.get('precio'), Decimal):
                disco['precio'] = float(disco['precio'])
        
        cursor.close()
        return discos
        
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener discos: {str(e)}")
    
    finally:
        if connection and connection.is_connected():
            connection.close()


@app.get("/api/discos/{disco_id}", response_model=Dict[str, Any])
async def get_disco(disco_id: int):
    connection = None
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        
        query = """
            SELECT id, nombre, artista, album, genero, anio_lanzamiento, 
                   sello_discografico, codigo_barras, precio, stock, 
                   imagen_url, fecha_agregado
            FROM discos
            WHERE id = %s
        """
        
        cursor.execute(query, (disco_id,))
        disco = cursor.fetchone()
        
        if isinstance(disco.get('precio'), Decimal):
            disco['precio'] = float(disco['precio'])
        
        cursor.close()
        
        if not disco:
            raise HTTPException(status_code=404, detail="Disco no encontrado")
        
        return disco
        
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener disco: {str(e)}")
    
    finally:
        if connection and connection.is_connected():
            connection.close()


@app.get("/api/generos", response_model=List[str])
async def get_generos():
    connection = None
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        query = "SELECT DISTINCT genero FROM discos ORDER BY genero"
        cursor.execute(query)
        
        generos = [row[0] for row in cursor.fetchall()]
        cursor.close()
        
        return generos
        
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error al obtener géneros: {str(e)}")
    
    finally:
        if connection and connection.is_connected():
            connection.close()


@app.put("/api/discos/{disco_id}")
async def update_disco(disco_id: int, payload: dict):
    connection = None
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        check_query = "SELECT * FROM discos WHERE id = %s"
        cursor.execute(check_query, (disco_id,))
        existing = cursor.fetchone()

        if not existing:
            cursor.close()
            raise HTTPException(status_code=404, detail="Disco no encontrado")

        nombre = payload.get("nombre", existing["nombre"])
        artista = payload.get("artista", existing["artista"])
        album = payload.get("album", existing["album"])
        genero = payload.get("genero", existing["genero"])
        anio_lanzamiento = payload.get("anio_lanzamiento", existing["anio_lanzamiento"])
        sello_discografico = payload.get("sello_discografico", existing["sello_discografico"])
        precio = payload.get("precio", existing["precio"])
        stock = payload.get("stock", existing["stock"])
        imagen_url = payload.get("imagen_url", existing["imagen_url"])

        update_query = """
            UPDATE discos 
            SET nombre = %s, artista = %s, album = %s, genero = %s,
                anio_lanzamiento = %s, sello_discografico = %s,
                precio = %s, stock = %s, imagen_url = %s
            WHERE id = %s
        """

        cursor.execute(update_query, (
            nombre, artista, album, genero, anio_lanzamiento,
            sello_discografico, precio, stock, imagen_url, disco_id
        ))
        connection.commit()
        cursor.close()

        return {"message": "Disco actualizado correctamente", "id": disco_id}

    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error al actualizar disco: {str(e)}")

    finally:
        if connection and connection.is_connected():
            connection.close()


@app.delete("/api/discos/{disco_id}")
async def delete_disco(disco_id: int):
    connection = None
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        check_query = "SELECT id FROM discos WHERE id = %s"
        cursor.execute(check_query, (disco_id,))
        
        if not cursor.fetchone():
            cursor.close()
            raise HTTPException(status_code=404, detail="Disco no encontrado")
        
        delete_query = "DELETE FROM discos WHERE id = %s"
        cursor.execute(delete_query, (disco_id,))
        connection.commit()
        
        cursor.close()
        
        return {"message": "Disco eliminado correctamente"}
        
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error al eliminar disco: {str(e)}")
    
    finally:
        if connection and connection.is_connected():
            connection.close()


@app.get("/ping")
async def ping() -> dict[str, str]:
    return {"ping": "pong"}


if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
    )
