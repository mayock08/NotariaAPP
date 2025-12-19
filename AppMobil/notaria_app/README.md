# Notaría Móvil - Flutter App

Aplicación móvil para el sistema notarial con autenticación biométrica y notificaciones en tiempo real.

## 🚀 Características

- ✅ **Login con Face ID/Touch ID** - Autenticación biométrica segura
- ✅ **Conexión con Backend** - Integración completa con API .NET Core
- ✅ **Seguimiento de Expedientes** - Timeline visual del proceso notarial
- ✅ **Perfil de Usuario** - Información personal y dirección
- ✅ **Notificaciones Push** - Firebase Cloud Messaging (preparado)
- ✅ **Tema Oscuro** - UI moderna con colores azul oscuro

## 📋 Requisitos Previos

- Flutter SDK 3.8.0 o superior
- Dart 3.8.0 o superior
- Android Studio / Xcode (para emuladores)
- Backend API corriendo en `https://localhost:5001`

## 🛠️ Instalación

### 1. Navegar al proyecto

```bash
cd AppMobil/notaria_app
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar URL del Backend

Edita `lib/services/auth_service.dart` y `lib/services/api_service.dart`:

```dart
// Para Android Emulator
static const String baseUrl = 'http://10.0.2.2:5001/api';

// Para iOS Simulator  
static const String baseUrl = 'http://localhost:5001/api';

// Para dispositivo físico (reemplaza con tu IP)
static const String baseUrl = 'http://192.168.1.100:5001/api';
```

## ▶️ Ejecutar la Aplicación

```bash
flutter run
```

## 🔐 Credenciales de Prueba

- **Email:** `juan.perez@example.com`
- **Password:** `password123`

## 📱 Pantallas Implementadas

1. **Login** - Email/password + Face ID
2. **Home** - Dashboard con expedientes
3. **Profile** - Información personal y dirección
4. **Process Tracking** - Timeline de proceso notarial

## 🔧 Solución de Problemas

### Error de certificado SSL

Cambia `https://localhost:5001` a `http://localhost:5000` en los servicios.

### Face ID no funciona

Solo funciona en dispositivos físicos o simuladores configurados.

### Backend no responde

Asegúrate de que el backend esté corriendo:
```bash
cd baked/NotariaAPI
dotnet run
```

Ver documentación completa en `FLUTTER_GUIDE.md`
