# docker-ps-memcache

Środowisko developerskie PrestaShop 9 z Memcached uruchamiane przez Docker.

## Wymagania

- Docker Desktop z WSL2 (Windows) lub Docker Engine (Linux/macOS)
- Git
- Bash

## Uruchomienie

### 1. Sklonuj repozytorium

```bash
git clone https://github.com/pszemo/docker-ps-memcache
cd docker-ps-memcache
```

### 2. Nadaj uprawnienia do skryptu setup

```bash
chmod +x setup.sh
```

### 3. Pobierz PrestaShop

```bash
./setup.sh
```

Skrypt pobierze i rozpakuje PrestaShop 9.0.2-2.1 do katalogu `prestashop/`.

### 4. Uruchom kontenery

```bash
docker compose up -d
```

Uruchamiane są trzy kontenery:
- **apache** — PHP 8.3 + Apache z rozszerzeniem Memcached
- **mysql** — MySQL 8.0
- **memcached** — Memcached 1.6

### 5. Zainstaluj PrestaShop

Otwórz w przeglądarce: `http://localhost:8081/install`

Dane do bazy danych:
 - Serwer: `mysql`
 - Użytkownik: `ps_user`
 - Hasło: `ps_password`
 - Nazwa bazy: `prestashop`

### 6. Usuń katalog instalacyjny

Po zakończeniu instalacji:

```bash
rm -rf prestashop/install/
```

### 7. Skonfiguruj Memcached w PrestaShop

W panelu administracyjnym przejdź do **Zaawansowane → Wydajność**:

1. **Użyj pamięci podręcznej** → `TAK`
2. **System buforowania** → `CacheMemcached`
3. Kliknij **Dodaj serwer** i wpisz:
   - Adres IP: `memcached`
   - Port: `11211`
   - Waga: `1`
4. Zapisz ustawienia

## Technologie

- PrestaShop 9.0.2
- PHP 8.3 + Apache
- MySQL 8.0
- Memcached 1.6
- Docker Compose

## Struktura projektu

```
docker-ps-memcache/
├── docker/
│   └── php/
│       ├── Dockerfile
│       ├── apache.conf
│       └── php.ini
├── prestashop/          # katalog z plikami PrestaShop (gitignore)
├── .env.example
├── .gitignore
├── docker-compose.yml
└── setup.sh
```