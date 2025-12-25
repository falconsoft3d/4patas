# 🐾 4Patas - PetCare App

Una aplicación móvil completa para iOS desarrollada con Flutter y Firebase para gestionar el cuidado de tus mascotas.

![Flutter](https://img.shields.io/badge/Flutter-3.38.4-blue)
![Firebase](https://img.shields.io/badge/Firebase-Ready-orange)
![iOS](https://img.shields.io/badge/iOS-Ready-black)

---

## 📱 Características

- ✅ **Gestión de Mascotas**: Crea y administra perfiles completos de tus mascotas
- 💉 **Control de Vacunas**: Programa y rastrea vacunas con recordatorios
- 📅 **Calendario**: Visualiza citas y eventos importantes
- 📊 **Estadísticas**: Dashboard con información de salud
- 🌓 **Modo Oscuro**: Soporte completo para tema claro y oscuro
- 🔥 **Sincronización**: Datos en tiempo real con Firebase
- 🎨 **Diseño Premium**: UI moderna basada en Material Design 3

---

## 🚀 Inicio Rápido

### Requisitos Previos

- Flutter 3.38.4 o superior
- Xcode (para iOS)
- Cuenta de Firebase (opcional para funcionalidad completa)

### Instalación

```bash
# Clonar el repositorio
cd 4patas

# Instalar dependencias
flutter pub get

# Ejecutar la app
flutter run
```

### Configurar Firebase (Opcional pero Recomendado)

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase
flutterfire configure
```

**📖 Ver guía completa**: [SETUP.md](SETUP.md)

---

## 📂 Estructura del Proyecto

```
4patas/
├── lib/
│   ├── config/          # Configuración (temas, constantes)
│   ├── models/          # Modelos de datos (Pet, Vaccine)
│   ├── screens/         # Pantallas de la app
│   ├── services/        # Servicios de Firebase
│   ├── utils/           # Utilidades y helpers
│   └── main.dart        # Punto de entrada
├── ios/                 # Proyecto iOS nativo
├── android/             # Proyecto Android nativo
├── test/                # Tests unitarios
├── stitch_4patas/       # Plantillas de diseño HTML originales
├── SETUP.md             # Guía de configuración detallada
├── PROJECT_SUMMARY.md   # Resumen completo del proyecto
└── VISUAL_GUIDE.md      # Guía visual con diagramas
```

---

## 🎨 Pantallas

### 1. Bienvenida
Pantalla de onboarding con diseño atractivo y call-to-action

### 2. Dashboard
Vista general de todas tus mascotas con estadísticas

### 3. Crear Mascota
Formulario completo para añadir nuevas mascotas

### 4. Detalles de Mascota
Información completa, vacunas y acciones rápidas

---

## 🛠️ Tecnologías

- **Framework**: Flutter 3.38.4
- **Lenguaje**: Dart 3.10.3
- **Backend**: Firebase (Firestore, Auth, Storage)
- **State Management**: Provider
- **Navegación**: GoRouter
- **UI**: Material Design 3 + Google Fonts (Epilogue)

---

## 📚 Documentación

- **[SETUP.md](SETUP.md)** - Guía completa de configuración y ejecución
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Resumen detallado del proyecto
- **[VISUAL_GUIDE.md](VISUAL_GUIDE.md)** - Guía visual con diagramas
- **[stitch_4patas/](stitch_4patas/)** - Plantillas HTML de diseño originales

---

## 🎯 Comandos Útiles

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Ver dispositivos disponibles
flutter devices

# Analizar código
flutter analyze

# Ejecutar tests
flutter test

# Limpiar proyecto
flutter clean

# Ver logs
flutter logs
```

---

## 🔥 Firebase Collections

### `pets`
```json
{
  "id": "uuid",
  "name": "Max",
  "type": "Perro",
  "breed": "Golden Retriever",
  "birthDate": "2020-01-15",
  "weight": 28.5,
  "gender": "Macho",
  "photoUrl": "https://...",
  "ownerId": "user-id",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### `vaccines`
```json
{
  "id": "uuid",
  "petId": "pet-uuid",
  "name": "Rabia",
  "scheduledDate": "2024-10-12",
  "status": "pending",
  "veterinarianName": "Dr. Sarah Wilson",
  "notes": "Vacuna anual",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

---

## 🎨 Paleta de Colores

| Color | Hex | Uso |
|-------|-----|-----|
| Primary | `#13EC5B` | Botones, acentos |
| Background Light | `#F6F8F6` | Fondo modo claro |
| Background Dark | `#102216` | Fondo modo oscuro |
| Surface Light | `#FFFFFF` | Cards modo claro |
| Surface Dark | `#1A2E22` | Cards modo oscuro |

---

## 🐛 Solución de Problemas

### Error: Firebase not initialized
```bash
flutterfire configure
```

### Error de compilación iOS
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

### Warnings de deprecación
Los warnings de `withOpacity` son solo informativos y no afectan la funcionalidad.

---

## 📝 Roadmap

- [x] Diseño UI completo
- [x] Navegación entre pantallas
- [x] Integración con Firebase
- [x] CRUD de mascotas
- [x] Gestión de vacunas
- [x] Modo oscuro
- [ ] Autenticación de usuarios
- [ ] Carga de fotos
- [ ] Notificaciones push
- [ ] Búsqueda de veterinarias
- [ ] Exportar a PDF

---

## 👨‍💻 Desarrollo

### Ejecutar en desarrollo

```bash
flutter run
```

### Build para producción

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
```

---

## 📄 Licencia

Desarrollado por **Marlon Falcon**  
© 2024 4Patas - PetCare App

---

## 🆘 Soporte

¿Necesitas ayuda? Revisa la documentación:

1. [SETUP.md](SETUP.md) - Configuración paso a paso
2. [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Resumen del proyecto
3. [VISUAL_GUIDE.md](VISUAL_GUIDE.md) - Guía visual

---

## ⭐ Características Destacadas

- 🎨 **Diseño Premium**: Basado en plantillas profesionales
- 🚀 **Alto Rendimiento**: Optimizado para iOS
- 🔄 **Tiempo Real**: Sincronización instantánea con Firebase
- 📱 **Responsive**: Adaptado a todos los tamaños de pantalla
- 🌍 **Internacionalización**: Preparado para múltiples idiomas
- ♿ **Accesibilidad**: Diseño inclusivo

---

**¡Tu app de gestión de mascotas está lista! 🐾**
