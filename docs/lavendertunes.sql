CREATE DATABASE IF NOT EXISTS lavendertunes;
USE lavendertunes;

CREATE USER IF NOT EXISTS 'ManuelPython'@'localhost' IDENTIFIED BY 'LavenderTunes';
GRANT ALL PRIVILEGES ON lavendertunes.* TO 'ManuelPython'@'localhost';
FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS discos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    artista VARCHAR(255) NOT NULL,
    album VARCHAR(255) NOT NULL,
    genero VARCHAR(100) NOT NULL,
    anio_lanzamiento INT,
    sello_discografico VARCHAR(150),
    codigo_barras VARCHAR(50) UNIQUE,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    imagen_url VARCHAR(500),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_artista (artista),
    INDEX idx_genero (genero),
    INDEX idx_nombre (nombre)
);

-- Datos de ejemplo
INSERT INTO discos (nombre, artista, album, genero, anio_lanzamiento, sello_discografico, codigo_barras, precio, stock, imagen_url) VALUES
('The Dark Side of the Moon', 'Pink Floyd', 'The Dark Side of the Moon', 'Rock Progresivo', 1973, 'Harvest Records', '5099902894713', 35.99, 15, 'https://example.com/darkside.jpg'),
('Rumours', 'Fleetwood Mac', 'Rumours', 'Rock', 1977, 'Warner Bros.', '7599270602', 32.99, 8, 'https://example.com/rumours.jpg'),
('Abbey Road', 'The Beatles', 'Abbey Road', 'Rock', 1969, 'Apple Records', '5099969945716', 39.99, 12, 'https://example.com/abbeyroad.jpg'),
('Thriller', 'Michael Jackson', 'Thriller', 'Pop', 1982, 'Epic Records', '5099750442111', 34.99, 20, 'https://example.com/thriller.jpg'),
('The Velvet Underground & Nico', 'The Velvet Underground', 'The Velvet Underground & Nico', 'Rock Alternativo', 1967, 'Verve Records', '8122795453', 42.99, 5, 'https://example.com/velvet.jpg'),
('Kind of Blue', 'Miles Davis', 'Kind of Blue', 'Jazz', 1959, 'Columbia Records', '5099751270614', 38.99, 10, 'https://example.com/kindofblue.jpg'),
('Nevermind', 'Nirvana', 'Nevermind', 'Grunge', 1991, 'DGC Records', '7203902440', 29.99, 18, 'https://example.com/nevermind.jpg'),
('Back to Black', 'Amy Winehouse', 'Back to Black', 'Soul', 2006, 'Island Records', '6024982180', 31.99, 14, 'https://example.com/backblack.jpg'),
('OK Computer', 'Radiohead', 'OK Computer', 'Rock Alternativo', 1997, 'Parlophone', '7243859390', 36.99, 7, 'https://example.com/okcomputer.jpg'),
('Random Access Memories', 'Daft Punk', 'Random Access Memories', 'Electrónica', 2013, 'Columbia Records', '8885465432', 44.99, 9, 'https://example.com/ram.jpg'),
('Blue Train', 'John Coltrane', 'Blue Train', 'Jazz', 1957, 'Blue Note Records', '7243582435', 41.99, 6, 'https://example.com/bluetrain.jpg'),
('Hotel California', 'Eagles', 'Hotel California', 'Rock', 1976, 'Asylum Records', '7559604362', 33.99, 11, 'https://example.com/hotelcalifornia.jpg'),
('Born to Run', 'Bruce Springsteen', 'Born to Run', 'Rock', 1975, 'Columbia Records', '5099751076919', 34.99, 13, 'https://example.com/borntorun.jpg'),
('Purple Rain', 'Prince', 'Purple Rain', 'Funk/Rock', 1984, 'Warner Bros.', '7599252361', 37.99, 10, 'https://example.com/purplerain.jpg'),
('Songs in the Key of Life', 'Stevie Wonder', 'Songs in the Key of Life', 'Soul/Funk', 1976, 'Tamla/Motown', '6003823', 49.99, 4, 'https://example.com/songskey.jpg');
