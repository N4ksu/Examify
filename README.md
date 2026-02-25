# Examify 🎓

Examify is a proctored assessment platform designed to ensure exam integrity. This repository contains both the Laravel backend and the Flutter web/mobile/desktop frontend.

## 🚀 Quick Start (Docker)

The easiest way to run the project on any computer is using **Docker**.

### 1. Prerequisites
- Install **[Docker Desktop](https://www.docker.com/products/docker-desktop/)**.
- Git installed.

### 2. Setup
Clone the repository and navigate into the project:
```bash
git clone https://github.com/N4ksu/Examify.git
cd Examify
```

### 3. Run the Project
Start all services (Database, Backend, and Frontend):
```bash
docker-compose up --build -d
```

### 4. Database Initialization (First Run Only)
Run the following command to set up the database and seed initial demo data:
```bash
docker exec -it examify_backend php artisan migrate --seed
```

### 5. Access the Apps
- **Frontend (Flutter Web)**: [http://localhost:8080](http://localhost:8080)
- **Backend API**: [http://localhost:8000/api](http://localhost:8000/api)

---

## 🛠 Manual Setup (XAMPP / Local)

If you don't want to use Docker, you can run the project using XAMPP for the database.

### 1. Database Setup (XAMPP)
- Open **XAMPP Control Panel** and start **Apache** and **MySQL**.
- Go to [http://localhost/phpmyadmin](http://localhost/phpmyadmin).
- Create a new database named `examify`.
- **Note**: You do NOT need to export/import SQL files. Laravel handles this via "Migrations".

### 2. Backend (Laravel)
Open your terminal in `examify-backend/`:
```bash
# 1. Install PHP dependencies
composer install

# 2. Setup your environment file
copy .env.example .env

# 3. Generate security key
php artisan key:generate

# 4. Configure .env
# Edit .env and set DB_DATABASE=examify, DB_USERNAME=root, DB_PASSWORD= (blank)

# 5. Run Migrations (This creates the tables automatically)
php artisan migrate --seed

# 6. Start the server
php artisan serve
```
*Backend will be at [http://localhost:8000](http://localhost:8000)*

### 3. Frontend (Flutter)
Open your terminal in `examify_flutter/`:
```bash
# 1. Get dependencies
flutter pub get

# 2. Run the web app
flutter run -d chrome
```

---

## 🔒 Proctoring Features
- **Full-Screen Enforcement**: Works on Web, Desktop, and Mobile.
- **Always on Top**: Supported on Windows.
- **Violation Logging**: Detects tab switching, window blurring, and app backgrounding.
