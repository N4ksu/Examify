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

## 🛠 Manual Setup (Development)

If you prefer to run the components separately without Docker:

### Backend (Laravel)
1. `cd examify-backend`
2. `composer install`
3. `copy .env.example .env` (update database credentials)
4. `php artisan key:generate`
5. `php artisan migrate --seed`
6. `php artisan serve`

### Frontend (Flutter)
1. `cd examify_flutter`
2. `flutter pub get`
3. `flutter run -d chrome` (for web)

## 🔒 Proctoring Features
- **Full-Screen Enforcement**: Works on Web, Desktop, and Mobile.
- **Always on Top**: Supported on Windows.
- **Violation Logging**: Detects tab switching, window blurring, and app backgrounding.
