# LavenderTunes - API REST de Discos de Vinilo

## Autor

- **Nombre:** Manuel Ignacio Gutiérrez Sivila
- **GitHub:** [https://github.com/Migs612/LavenderTunes-Python](https://github.com/Migs612/LavenderTunes-Python)

## Descripción

LavenderTunes es una API REST para gestionar un catálogo de discos de vinilo. Permite realizar operaciones CRUD completas (Crear, Leer, Actualizar y Eliminar) sobre una base de datos MySQL, con acceso directo mediante sentencias SQL sin utilizar ORM.

Además integra la API de Spotify para buscar álbumes y agregarlos al catálogo directamente.

## Tecnologías utilizadas

- **Backend:** Python 3.12 con FastAPI
- **Base de datos:** MySQL (acceso directo con `mysql-connector-python`, sin ORM)
- **Frontend:** HTML5, CSS3, JavaScript
- **API externa:** Spotify Web API

## Estructura del proyecto

```
LavenderTunes-Python/
├── app/
│   ├── main.py                  # API REST (endpoints CRUD + Spotify)
│   ├── static/
│   │   ├── css/
│   │   │   └── styles.css       # Estilos de la interfaz
│   │   └── js/
│   │       └── spotify_search.js # Lógica de búsqueda en Spotify
│   └── templates/
│       └── pages/
│           └── index.html       # Interfaz web principal
├── docs/
│   └── lavendertunes.sql        # Script SQL de inicialización
├── .env.example                 # Variables de entorno de ejemplo
├── requirements.txt             # Dependencias de Python
└── README.md
```

## Endpoints de la API

| Método | Ruta                      | Descripción                        |
|--------|---------------------------|------------------------------------|
| GET    | `/api/discos`             | Obtener todos los discos           |
| GET    | `/api/discos/{id}`        | Obtener un disco por ID            |
| POST   | `/api/discos/from_spotify`| Crear un disco desde Spotify       |
| PUT    | `/api/discos/{id}`        | Actualizar un disco por ID         |
| DELETE | `/api/discos/{id}`        | Eliminar un disco por ID           |
| GET    | `/api/generos`            | Obtener lista de géneros           |
| GET    | `/api/spotify/search?q=`  | Buscar álbumes en Spotify          |

## Instrucciones para ejecutar

### 1. Clonar el repositorio

```bash
git clone https://github.com/Migs612/LavenderTunes-Python.git
cd LavenderTunes-Python
```

### 2. Crear la base de datos

Ejecutar el script SQL en MySQL:

```bash
mysql -u root -p < docs/lavendertunes.sql
```

### 3. Configurar las variables de entorno

Copiar el archivo de ejemplo y editarlo con tus credenciales:

```bash
cp .env.example .env
```

Contenido del `.env`:

```
DB_HOST=localhost
DB_USER=ManuelPython
DB_PASSWORD=LavenderTunes
DB_NAME=lavendertunes
SPOTIFY_CLIENT_ID=tu_client_id
SPOTIFY_CLIENT_SECRET=tu_client_secret
```

### 4. Crear entorno virtual e instalar dependencias

```bash
python -m venv venv
venv\Scripts\activate        # Windows
pip install -r requirements.txt
```

### 5. Ejecutar el servidor

```bash
uvicorn app.main:app --reload --port 8000
```

La aplicación estará disponible en `http://localhost:8000`

La documentación automática de la API en `http://localhost:8000/docs`
