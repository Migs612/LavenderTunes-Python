document.addEventListener('DOMContentLoaded', () => {
    const openBtn = document.getElementById('openSpotifyBtn');
    const panel = document.getElementById('spotifyPanel');
    const searchInput = document.getElementById('spotifySearchInput');
    const searchBtn = document.getElementById('spotifySearchBtn');
    const resultsDiv = document.getElementById('spotifyResults');
    const albumDetailsPanel = document.getElementById('albumDetailsPanel');
    const priceInput = document.getElementById('selectedAlbumPrice');
    const stockInput = document.getElementById('selectedAlbumStock');
    const saveBtn = document.getElementById('saveAlbumBtn');
    const cancelBtn = document.getElementById('cancelAlbumBtn');
    const albumInfoDiv = document.getElementById('selectedAlbumInfo');

    if (!openBtn || !panel) {
        return;
    }

    let selectedAlbum = null;

    openBtn.addEventListener('click', () => {
        if (panel.style.display === 'none' || !panel.style.display) {
            panel.style.display = 'block';
            openBtn.textContent = 'Cerrar Spotify';
            if (searchInput) searchInput.focus();
        } else {
            panel.style.display = 'none';
            openBtn.textContent = 'Agregar desde Spotify';
            resetPanel();
        }
    });

    if (searchBtn) {
        searchBtn.addEventListener('click', searchAlbums);
    }
    if (searchInput) {
        searchInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                searchAlbums();
            }
        });
    }

    async function searchAlbums() {
        const query = searchInput?.value?.trim();
        if (!query || !resultsDiv) return;

        resultsDiv.innerHTML = '<div class="loading">Buscando en Spotify...</div>';
        
        try {
            const response = await fetch(`/api/spotify/search?q=${encodeURIComponent(query)}`);
            if (!response.ok) throw new Error('Error en la búsqueda');
            
            const albums = await response.json();

            if (!albums.length) {
                resultsDiv.innerHTML = '<div class="no-results">No se encontraron álbumes</div>';
                return;
            }

            displayAlbums(albums);

        } catch (error) {
            resultsDiv.innerHTML = `<div class="error">Error: ${error.message}</div>`;
        }
    }

    function displayAlbums(albums) {
        if (!resultsDiv) return;
        
        resultsDiv.innerHTML = '';
        
        albums.forEach(album => {
            const card = document.createElement('div');
            card.className = 'spotify-album-card';
            card.innerHTML = `
                <div class="album-image">
                    ${album.image_url ? `<img src="${album.image_url}" alt="${album.name}" onerror="this.style.display='none'">` : '[Imagen]'}
                </div>
                <div class="album-info">
                    <div class="album-name">${album.name}</div>
                    <div class="album-artists">${album.artists}</div>
                    <div class="album-meta">${album.release_date} · ${album.total_tracks} tracks</div>
                    <button class="selectAlbumBtn">Seleccionar</button>
                </div>
            `;

            const selectBtn = card.querySelector('.selectAlbumBtn');
            if (selectBtn) {
                selectBtn.addEventListener('click', () => selectAlbum(album));
            }

            resultsDiv.appendChild(card);
        });
    }

    function selectAlbum(album) {
        selectedAlbum = album;
        
        if (albumInfoDiv) {
            albumInfoDiv.innerHTML = `
                <div class="preview-image">
                    ${album.image_url ? `<img src="${album.image_url}" alt="${album.name}">` : '[Imagen]'}
                </div>
                <div class="preview-info">
                    <h5>${album.name}</h5>
                    <p>${album.artists} · ${album.release_date}</p>
                </div>
            `;
        }
        
        if (priceInput) priceInput.value = '';
        if (stockInput) stockInput.value = '1';
        if (albumDetailsPanel) albumDetailsPanel.style.display = 'block';
        
        if (albumDetailsPanel) {
            albumDetailsPanel.scrollIntoView({ 
                behavior: 'smooth', 
                block: 'center' 
            });
        }
        

        setTimeout(() => {
            if (priceInput) priceInput.focus();
        }, 300);
    }

    if (saveBtn) {
        saveBtn.addEventListener('click', async () => {
            const price = priceInput ? parseFloat(priceInput.value) : NaN;
            const stock = stockInput ? parseInt(stockInput.value) || 1 : 1;
            
            if (isNaN(price) || price < 0) {
                alert('Por favor introduce un precio válido');
                if (priceInput) priceInput.focus();
                return;
            }

            if (stock < 1) {
                alert('La cantidad debe ser al menos 1');
                if (stockInput) stockInput.focus();
                return;
            }

            if (!selectedAlbum) {
                alert('No hay álbum seleccionado');
                return;
            }

            saveBtn.disabled = true;
            saveBtn.innerHTML = '<span class="btn-icon">Loading</span>Guardando...';

            try {
                const payload = {
                    spotify_id: selectedAlbum.id,
                    name: selectedAlbum.name,
                    artists: selectedAlbum.artists,
                    release_date: selectedAlbum.release_date,
                    image_url: selectedAlbum.image_url,
                    price: price,
                    stock: stock
                };

                const response = await fetch('/api/discos/from_spotify', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                if (response.status === 409) {
                    alert('Este disco ya existe en el catálogo');
                } else if (!response.ok) {
                    const errorText = await response.text();
                    throw new Error(errorText || 'Error al guardar');
                } else {
                    const data = await response.json();
                    showSuccessMessage();
                    addToRecentlyAdded(selectedAlbum, price, stock);
                    
                    if (window.loadRecords) window.loadRecords();
                }
            } catch (error) {
                alert(`Error: ${error.message}`);
            } finally {
                saveBtn.disabled = false;
                saveBtn.innerHTML = '<span class="btn-icon">Save</span>Agregar al Catálogo';
            }

            if (albumDetailsPanel) albumDetailsPanel.style.display = 'none';
            selectedAlbum = null;
        });
    }

    if (cancelBtn) {
        cancelBtn.addEventListener('click', () => {
            if (albumDetailsPanel) albumDetailsPanel.style.display = 'none';
            selectedAlbum = null;
        });
    }

    function showSuccessMessage() {
        const message = document.createElement('div');
        message.className = 'success-message';
        message.innerHTML = 'Disco agregado exitosamente al catálogo';
        message.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #4CAF50;
            color: white;
            padding: 15px 20px;
            border-radius: 6px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 1000;
            animation: slideIn 0.3s ease;
        `;
        
        document.body.appendChild(message);
        
        setTimeout(() => {
            message.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => message.remove(), 300);
        }, 3000);
    }

    function addToRecentlyAdded(album, price, stock) {
        const selectionsContainer = document.querySelector('.selections-grid');
        if (!selectionsContainer) return;
        
        const item = document.createElement('div');
        item.className = 'recently-added-item';
        item.innerHTML = `
            <div class="recently-added-image">
                ${album.image_url ? `<img src="${album.image_url}" alt="${album.name}">` : '[Imagen]'}
            </div>
            <div class="recently-added-info">
                <h6>${album.name}</h6>
                <p>${album.artists}</p>
                <div class="price-stock">$${price.toFixed(2)} · ${stock} unidades</div>
            </div>
        `;

        selectionsContainer.insertBefore(item, selectionsContainer.firstChild);
        
        while (selectionsContainer.children.length > 5) {
            selectionsContainer.removeChild(selectionsContainer.lastChild);
        }
    }

    function resetPanel() {
        if (resultsDiv) resultsDiv.innerHTML = '';
        if (albumDetailsPanel) albumDetailsPanel.style.display = 'none';
        selectedAlbum = null;
        if (searchInput) searchInput.value = '';
    }
});
