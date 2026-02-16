SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


CREATE USER IF NOT EXISTS 'ManuelPython'@'%' IDENTIFIED BY 'LavenderTunes';
GRANT ALL PRIVILEGES ON lavendertunes.* TO 'ManuelPython'@'%';
FLUSH PRIVILEGES;


CREATE TABLE `discos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `artista` varchar(255) NOT NULL,
  `album` varchar(255) NOT NULL,
  `genero` varchar(100) NOT NULL,
  `anio_lanzamiento` int(11) DEFAULT NULL,
  `sello_discografico` varchar(150) DEFAULT NULL,
  `codigo_barras` varchar(50) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `imagen_url` varchar(500) DEFAULT NULL,
  `fecha_agregado` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `discos` (`id`, `nombre`, `artista`, `album`, `genero`, `anio_lanzamiento`, `sello_discografico`, `codigo_barras`, `precio`, `stock`, `imagen_url`, `fecha_agregado`) VALUES
(23, 'The Fate of Ophelia (Remix)', 'Taylor Swift', 'The Fate of Ophelia', 'Pop', 2024, 'Republic Records', 'TS-264E9', 12.99, 45, 'https://i.scdn.co/image/ab67616d0000b2735a9197396cb52631e73364b9', '2026-01-20 11:16:37'),
(24, 'SOUR', 'Olivia Rodrigo', 'SOUR', 'Pop-Rock', 2021, 'Geffen Records', 'OR-6S84U', 19.22, 81, 'https://i.scdn.co/image/ab67616d0000b273a91c10fe9472d9bd89802e5a', '2026-01-20 11:16:37'),
(25, 'make you mine', 'Madison Beer', 'make you mine', 'Dance-Pop', 2024, 'Epic Records', 'MB-62G7J', 18.03, 92, 'https://i.scdn.co/image/ab67616d0000b273e0fbdeed0ac9e8daca2d9bd1', '2026-01-20 11:16:37'),
(26, 'SO CLOSE TO WHAT???', 'Tate McRae', 'SO CLOSE TO WHAT???', 'Pop', 2025, 'RCA Records', 'TM-4AIX5', 18.94, 33, 'https://i.scdn.co/image/ab67616d0000b273c40dccc1952bb5ed96986869', '2026-01-20 11:16:37'),
(28, 'Short n\' Sweet', 'Sabrina Carpenter', 'Short n\' Sweet', 'Pop', 2024, 'Island Records', 'SC-3IPSV', 17.68, 33, 'https://i.scdn.co/image/ab67616d0000b273fd8d7a8d96871e791cb1f626', '2026-01-20 11:16:37'),
(30, 'QUE NOS FALTE TODO', 'Luck Ra', 'QUE NOS FALTE TODO', 'Cuarteto', 2024, 'Sony Music Argentina', 'LR-3X0T1', 18.38, 33, 'https://i.scdn.co/image/ab67616d0000b273db091e5bdcd06ef5b252366d', '2026-01-20 11:16:37'),
(31, 'AMERI', 'Duki', 'AMERI', 'Trap Latino', 2024, 'Dale Play Records', 'DK-3RVK4', 16.84, 21, 'https://i.scdn.co/image/ab67616d0000b273ee67e1ebdbc7a30772972a48', '2026-01-20 11:16:37'),
(32, 'XSCAPE', 'Michael Jackson', 'XSCAPE', 'Pop/R&B', 2014, 'Epic Records', 'MJ-7POMP', 19.15, 51, 'https://i.scdn.co/image/ab67616d0000b27335f36cb686b0d5a12ab3a9f0', '2026-01-20 11:16:37'),
(33, 'The Bends', 'Radiohead', 'The Bends', 'Alt Rock', 1995, 'Parlophone', 'RH-35UJL', 16.98, 64, 'https://i.scdn.co/image/ab67616d0000b2739293c743fa542094336c5e12', '2026-01-20 11:16:37'),
(34, 'HIT ME HARD AND SOFT', 'Billie Eilish', 'HIT ME HARD AND SOFT', 'Art Pop', 2024, 'Darkroom/Interscope', 'BE-7AJUG', 16.77, 44, 'https://i.scdn.co/image/ab67616d0000b27371d62ea7ea8a5be92d3c1f62', '2026-01-20 11:16:37'),
(35, 'Le Clique: Vida Rockstar (X)', 'JHAYCO', 'Le Clique', 'Reggaetón', 2024, 'Universal Latino', 'JH-67JIM', 18.45, 68, 'https://i.scdn.co/image/ab67616d0000b273ed133ea8f343f0f451346a44', '2026-01-20 11:16:37'),
(36, 'Pitcher', 'Yan Block', 'Pitcher', 'Urbano', 2023, 'Wave Music', 'YB-2K98C', 18.94, 97, 'https://i.scdn.co/image/ab67616d0000b273133ae9818c5ac2eeda0930de', '2026-01-20 11:16:37'),
(39, 'The New Abnormal', 'The Strokes', 'The New Abnormal', 'Indie Rock', 2020, 'RCA Records', 'TS-2XKZV', 17.68, 36, 'https://i.scdn.co/image/ab67616d0000b273e3f1ba3de4659708c25d0f39', '2026-01-20 11:16:37'),
(40, 'AFTERCARE', 'Nessa Barrett', 'AFTERCARE', 'Alt-Pop', 2024, 'Warner Records', 'NB-6H9OV', 18.31, 22, 'https://i.scdn.co/image/ab67616d0000b2738d345d8baf0c3899501a4bb3', '2026-01-20 11:16:37'),
(41, 'SAKURA', 'SAIKO', 'SAKURA', 'Urbano Español', 2024, 'Sony Music Spain', 'SK-5Z4AZ', 19.22, 96, 'https://i.scdn.co/image/ab67616d0000b273e346fc6f767ca2ac8365fe60', '2026-01-20 11:16:37'),
(42, 'The Secret of Us', 'Gracie Abrams', 'The Secret of Us', 'Indie Pop', 2024, 'Interscope Records', 'GA-0HBRQ', 17.54, 41, 'https://i.scdn.co/image/ab67616d0000b2731dac3694b3289cd903cb3acf', '2026-01-20 11:16:37'),
(43, 'THE TORTURED POETS DEPARTMENT', 'Taylor Swift', 'TTPD: The Anthology', 'Synth-Pop', 2024, 'Republic Records', 'TS-5H7IX', 17.82, 39, 'https://i.scdn.co/image/ab67616d0000b2738ecc33f195df6aa257c39eaa', '2026-01-20 11:16:37'),
(47, 'Christmas', 'Michael Bublé', 'Christmas', 'Swing/Jazz', 2011, 'Reprise Records', 'MB-6UUAX', 17.61, 25, 'https://i.scdn.co/image/ab67616d0000b273fb760f483d31372071a23247', '2026-01-20 11:16:37'),
(49, 'Kid Krow', 'Conan Gray', 'Kid Krow', 'Indie Pop', 2020, 'Republic Records', 'CG-2CMLK', 17.54, 52, 'https://i.scdn.co/image/ab67616d0000b27388e3cda6d29b2552d4d6bc43', '2026-01-20 11:16:37'),
(50, 'Wincents Weisse Weihnachten', 'Wincent Weiss', 'Wincents Weisse Weihnachten', 'Pop Alemán', 2023, 'Vertigo Berlin', 'WW-2WQ8X', 18.45, 62, 'https://i.scdn.co/image/ab67616d0000b2730618583698a666d807c6a513', '2026-01-20 11:16:37'),
(51, 'You\'ll Be Alright, Kid', 'Alex Warren', 'You\'ll Be Alright, Kid', 'Pop', 2024, 'Atlantic Records', 'AW-1ECGY', 18.66, 42, 'https://i.scdn.co/image/ab67616d0000b27342fe69c0e7e5c92f01ece8ce', '2026-01-20 11:16:37'),
(53, 'Riot!', 'Paramore', 'Riot!', 'Pop-Punk', 2007, 'Fueled by Ramen', 'PM-3UOOO', 17.75, 52, 'https://i.scdn.co/image/ab67616d0000b27369966efa45b125ed6711b43c', '2026-01-20 11:16:37'),
(54, 'PRIMERA MUSA', 'Omar Courtz', 'PRIMERA MUSA', 'Reggaetón', 2024, 'Mr. 305 Records', 'OC-3C5UW', 17.47, 91, 'https://i.scdn.co/image/ab67616d0000b273996764071dbd5240eefb2422', '2026-01-20 11:16:37'),
(55, 'UNA SEMANA INCREÍBLE', 'La Pantera', 'UNA SEMANA INCREÍBLE', 'Urbano', 2024, 'Pantera Music', 'LP-6LAF0', 18.31, 65, 'https://i.scdn.co/image/ab67616d0000b273c75c4d3d60cb712612fb8430', '2026-01-20 11:16:37'),
(56, 'Quién es Dei V?', 'Dei V', 'Quién es Dei V?', 'Trap', 2024, 'Under Water Music', 'DV-2R23A', 16.98, 32, 'https://i.scdn.co/image/ab67616d0000b2731f8fe922095e679d71b2be7d', '2026-01-20 11:16:37'),
(57, 'Submarine', 'The Marías', 'Submarine', 'Indie Pop', 2024, 'Nice Life', 'TM-03GUX', 18.38, 50, 'https://i.scdn.co/image/ab67616d0000b273b19ac38a59cddd80da3cedcb', '2026-01-20 11:16:37'),
(58, 'From Zero', 'Linkin Park', 'From Zero', 'Nu Metal', 2024, 'Warner Records', 'LP-4R6FV', 19.36, 77, 'https://i.scdn.co/image/ab67616d0000b273b11a5489e8cb11dd22b930a0', '2026-01-20 11:16:37'),
(59, 'Seductive', 'Luciano', 'Seductive', 'German Drill', 2024, 'Locosquad', 'LU-75BI4', 18.10, 29, 'https://i.scdn.co/image/ab67616d0000b273d811db49fcc425d11b713498', '2026-01-20 11:16:37'),
(61, 'In Liebe', 'AYLIVA', 'In Liebe', 'R&B Alemán', 2024, 'WhiteLiva', 'AY-3CB6T', 17.19, 28, 'https://i.scdn.co/image/ab67616d0000b2738bdf6a4309ec137eeb64befc', '2026-01-20 11:16:37'),
(62, 'Christmas 2025', 'Various Artists', 'Christmas 2025', 'Navideño', 2025, 'Various Labels', 'VA-3QJ7W', 19.15, 55, 'https://i.scdn.co/image/ab67616d0000b2732e3c3b8d6f27c50f1093d16d', '2026-01-20 11:16:37'),
(63, 'NINETYNINE', 'Jazeek', 'NINETYNINE', 'Trap Alemán', 2024, 'Jazeek Music', 'JZ-6J4H7', 19.57, 33, 'https://i.scdn.co/image/ab67616d0000b273d0d9cb06513819a6a697894e', '2026-01-20 11:16:37'),
(66, 'Weihnachten 2025', 'Various Artists', 'Weihnachten 2025', 'Navideño', 2025, 'Universal Music', 'VA-4GLTS', 19.29, 68, 'https://i.scdn.co/image/ab67616d0000b2739b96f0eeb1db27ddec61543a', '2026-01-20 11:16:37'),
(67, 'Off the Wall', 'Michael Jackson', 'Off the Wall', 'Disco/Funk', 1979, 'Epic Records', 'MJ-2ZYTN', 17.47, 86, 'https://i.scdn.co/image/ab67616d0000b27344e53f6377a1e99e13779af9', '2026-01-20 11:16:37'),
(68, 'Thriller', 'Michael Jackson', 'Thriller', 'Pop', 1982, 'Epic Records', 'MJ-2ANVO', 19.43, 96, 'https://i.scdn.co/image/ab67616d0000b27332a7d87248d1b75463483df5', '2026-01-20 11:16:37'),
(69, 'Dangerous', 'Michael Jackson', 'Dangerous', 'New Jack Swing', 1991, 'Epic Records', 'MJ-0OX4S', 16.77, 41, 'https://i.scdn.co/image/ab67616d0000b273bf4cf0f48b94d0c8297b751a', '2026-01-20 11:16:37'),
(70, 'BLOOD ON THE DANCE FLOOR', 'Michael Jackson', 'Blood on the Dance Floor', 'Electronic/Pop', 1997, 'Epic Records', 'MJ-0RNSF', 19.08, 60, 'https://i.scdn.co/image/ab67616d0000b273777230e2062652ea3818f1d4', '2026-01-20 11:16:37'),
(71, 'Invincible', 'Michael Jackson', 'Invincible', 'R&B', 2001, 'Epic Records', 'MJ-52E4R', 18.66, 78, 'https://i.scdn.co/image/ab67616d0000b27376bfd700e0c47fae7f2c7b75', '2026-01-20 11:16:37'),
(72, 'HIStory', 'Michael Jackson', 'HIStory: Past, Present...', 'Pop/Soul', 1995, 'Epic Records', 'MJ-3OBHN', 17.05, 27, 'https://i.scdn.co/image/ab67616d0000b273b4a878f008a0eda552446701', '2026-01-20 11:16:37'),
(73, 'Bad (Remastered)', 'Michael Jackson', 'Bad', 'Pop/Rock', 1987, 'Epic Records', 'MJ-3US57', 17.47, 41, 'https://i.scdn.co/image/ab67616d0000b2732e0cd1330748a5b7764dd562', '2026-01-20 11:16:37'),
(75, 'Michael', 'Michael Jackson', 'Michael', 'Pop', 2010, 'Epic/Sony Music', 'MJ-5S7YS', 17.40, 27, 'https://i.scdn.co/image/ab67616d0000b273a7ef06d1e0bad6fe2ff028f6', '2026-01-20 11:16:37'),
(76, 'Number Ones', 'Michael Jackson', 'Number Ones', 'Pop/Soul', 2003, 'Epic Records', 'MJ-1JCYW', 18.24, 73, 'https://i.scdn.co/image/ab67616d0000b273eb15b69407230b713423d3cb', '2026-01-20 11:16:37'),
(77, 'Thriller 40', 'Michael Jackson', 'Thriller 40', 'Pop', 2022, 'Epic/Legacy', 'MJ-57TZH', 18.45, 20, 'https://i.scdn.co/image/ab67616d0000b2734cd83028e3741cda57d0c4bc', '2026-01-20 11:16:37'),
(78, 'This Is It', 'Michael Jackson', 'This Is It', 'Pop', 2009, 'Epic/Sony', 'MJ-7PMVC', 18.10, 24, 'https://i.scdn.co/image/ab67616d0000b27379b8d5f5821bddae3bc5e6a9', '2026-01-20 11:16:37'),
(79, 'Bad 25th Anniversary', 'Michael Jackson', 'Bad 25', 'Pop', 2012, 'Epic Records', 'MJ-24TAU', 17.68, 40, 'https://i.scdn.co/image/ab67616d0000b273605223665713cdf285ee0c81', '2026-01-20 11:16:37'),
(81, 'Thriller 25 Super Deluxe', 'Michael Jackson', 'Thriller 25', 'Pop', 2008, 'Epic Records', 'MJ-1C2H7', 18.10, 30, 'https://i.scdn.co/image/ab67616d0000b2734121faee8df82c526cbab2be', '2026-01-20 11:16:37'),
(82, 'The Essential', 'Michael Jackson', 'The Essential', 'Compilation', 2005, 'Sony Music', 'MJ-77DNY', 19.29, 89, 'https://i.scdn.co/image/ab67616d0000b2736c1748b440eb462a19f24eec', '2026-01-20 11:16:37'),
(83, 'Scream', 'Michael Jackson', 'Scream', 'Dance-Pop', 2017, 'Epic/Legacy', 'MJ-2X8UO', 19.57, 95, 'https://i.scdn.co/image/ab67616d0000b2735466c65c2134b833df466076', '2026-01-20 11:16:37'),
(85, 'Christmas Album', 'The Jackson 5', 'Christmas Album', 'Soul/Motown', 1970, 'Motown Records', 'J5-5M8U1', 17.96, 75, 'https://i.scdn.co/image/ab67616d0000b27308a0fe33e91b991d2c9c9cde', '2026-01-20 11:16:37'),
(86, 'AM', 'Arctic Monkeys', 'AM', 'Desconocido', 2013, NULL, '78bpIziExqiI9qztvNFlQu', 20.50, 1, 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', '2026-01-27 11:50:32');

ALTER TABLE `discos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_barras` (`codigo_barras`),
  ADD KEY `idx_artista` (`artista`),
  ADD KEY `idx_genero` (`genero`),
  ADD KEY `idx_nombre` (`nombre`);

ALTER TABLE `discos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;
COMMIT;