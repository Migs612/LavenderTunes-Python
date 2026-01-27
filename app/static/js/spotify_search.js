document.addEventListener('DOMContentLoaded', () => {
    const openBtn = document.getElementById('openSpotifyBtn');
    const panel = document.getElementById('spotifyPanel');
    const searchInput = document.getElementById('spotifySearchInput');
    const searchBtn = document.getElementById('spotifySearchBtn');
    const resultsDiv = document.getElementById('spotifyResults');
    const priceRow = document.getElementById('priceRow');
    const priceInput = document.getElementById('selectedAlbumPrice');
    const saveBtn = document.getElementById('saveAlbumBtn');
    const cancelBtn = document.getElementById('cancelAlbumBtn');

    let selectedAlbum = null;

    openBtn.addEventListener('click', () => {
        if (panel.style.display === 'none' || !panel.style.display) {
            panel.style.display = 'block';
            openBtn.textContent = 'Cerrar';
        } else {
            panel.style.display = 'none';
            openBtn.textContent = 'Agregar desde Spotify';
            resultsDiv.innerHTML = '';
            priceRow.style.display = 'none';
        }
    });

    searchBtn.addEventListener('click', async () => {
        const q = searchInput.value.trim();
        if (!q) return;
        resultsDiv.innerHTML = '<div class="loading">Buscando...</div>';
        try {
            const resp = await fetch(`/api/spotify/search?q=${encodeURIComponent(q)}`);
            if (!resp.ok) throw new Error('Error en búsqueda');
            const albums = await resp.json();

            if (!albums.length) {
                resultsDiv.innerHTML = '<div class="no-results">No se encontraron álbumes</div>';
                return;
            }

            resultsDiv.innerHTML = '';
            albums.forEach(a => {
                const card = document.createElement('div');
                card.className = 'spotify-album-card';
                card.innerHTML = `
                    <div class="album-image">${a.image_url ? `<img src="${a.image_url}" alt="${a.name}" onerror="this.style.display='none'">` : '🎵'}</div>
                    <div class="album-info">
                        <div class="album-name">${a.name}</div>
                        <div class="album-artists">${a.artists}</div>
                        <div class="album-meta">${a.release_date} · ${a.total_tracks} tracks</div>
                        <button class="selectAlbumBtn">Seleccionar</button>
                    </div>
                `;

                const selectBtn = card.querySelector('.selectAlbumBtn');
                selectBtn.addEventListener('click', () => {
                    selectedAlbum = a;
                    priceRow.style.display = 'flex';
                    priceInput.value = '';
                    // Scroll into view
                    priceRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
                });

                resultsDiv.appendChild(card);
            });

        } catch (err) {
            resultsDiv.innerHTML = `<div class="error">${err.message}</div>`;
        }
    });

    saveBtn.addEventListener('click', async () => {
        const price = parseFloat(priceInput.value);
        if (isNaN(price) || price < 0) {
            alert('Introduce un precio válido');
            return;
        }

        if (!selectedAlbum) {
            alert('No hay álbum seleccionado');
            return;
        }

        const albumData = selectedAlbum; // capture

        // Immediately POST to backend to persist
        try {
            const body = {
                spotify_id: albumData.id,
                name: albumData.name,
                artists: albumData.artists,
                release_date: albumData.release_date,
                image_url: albumData.image_url,
                price: price
            };

            const resp = await fetch('/api/discos/from_spotify', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });

            if (resp.status === 409) {
                alert('Este disco ya existe en el catálogo.');
            } else if (!resp.ok) {
                const text = await resp.text();
                throw new Error(text || 'Error al guardar');
            } else {
                // Success
                const data = await resp.json();
                alert('Disco agregado al catálogo.');
                if (window.loadRecords) window.loadRecords();
            }
        } catch (err) {
            alert('Error guardando en el servidor: ' + (err.message || err));
        }

        // Show confirmation in selections panel (non-interactive)
        const selectionsContainer = document.getElementById('spotifySelections');
        const infoCard = document.createElement('div');
        infoCard.className = 'selected-album-card';
        infoCard.innerHTML = `
            <div class="selected-album-image">${albumData.image_url ? `<img src="${albumData.image_url}" alt="${albumData.name}" onerror="this.style.display='none'">` : '🎵'}</div>
            <div class="selected-album-info">
                <div class="selected-album-name">${albumData.name}</div>
                <div class="selected-album-artists">${albumData.artists}</div>
                <div class="selected-album-meta">${albumData.release_date}</div>
                <div class="selected-album-price">Precio: $${price.toFixed(2)}</div>
            </div>
        `;

        selectionsContainer.insertBefore(infoCard, selectionsContainer.firstChild);

        // Cleanup UI
        priceRow.style.display = 'none';
        priceInput.value = '';
        selectedAlbum = null;
    });

    cancelBtn.addEventListener('click', () => {
        priceRow.style.display = 'none';
        selectedAlbum = null;
    });
});
