# 🚀 Guía de Configuración y Ejecución - PetCare App

## ✅ Estado Actual del Proyecto

La aplicación Flutter está **completamente funcional** y lista para ejecutarse. Solo necesitas configurar Firebase para habilitar la funcionalidad de base de datos.

### Pantallas Implementadas:
- ✅ Pantalla de Bienvenida (Onboarding)
- ✅ Dashboard de Mascotas
- ✅ Formulario de Creación de Mascota
- ✅ Detalles de Mascota con Vacunas
- ✅ Navegación completa con GoRouter

### Características:
- 🎨 Diseño basado en tus plantillas HTML
- 🌓 Soporte para modo claro/oscuro
- 📱 Optimizado para iOS
- 🔥 Integración con Firebase (Firestore, Auth, Storage)
- 🎯 Gestión de estado con Provider

---

## 📋 Pasos para Ejecutar la App

### Opción 1: Ejecutar SIN Firebase (Solo UI)

Si solo quieres ver la interfaz sin funcionalidad de base de datos:

```bash
cd petcare_app

# Ejecutar en simulador iOS
flutter run

# O seleccionar dispositivo específico
flutter devices
flutter run -d <device-id>
```

**Nota:** La app se ejecutará pero no podrá guardar datos sin Firebase configurado.

---

### Opción 2: Configurar Firebase (Recomendado)

#### Paso 1: Instalar FlutterFire CLI

```bash
# Activar FlutterFire CLI globalmente
dart pub global activate flutterfire_cli

# Verificar instalación
flutterfire --version
```

#### Paso 2: Crear Proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o usa uno existente
3. Nombre sugerido: `petcare-app`

#### Paso 3: Configurar Firebase en el Proyecto

```bash
cd petcare_app

# Autenticarse con Firebase (abrirá navegador)
firebase login

# Configurar Firebase para Flutter
flutterfire configure
```

El comando `flutterfire configure` te preguntará:
- ✅ Selecciona tu proyecto de Firebase
- ✅ Selecciona las plataformas: **iOS** (y Android si quieres)
- ✅ Confirma el Bundle ID: `com.falconsoft3d.petcare.petcareApp`

Esto creará automáticamente:
- `lib/firebase_options.dart` (configuración)
- `ios/firebase_app_id_file.json`
- `ios/Runner/GoogleService-Info.plist`

#### Paso 4: Habilitar Servicios en Firebase Console

1. **Firestore Database**:
   - Ve a Firestore Database en Firebase Console
   - Clic en "Crear base de datos"
   - Selecciona modo: **Modo de prueba** (para desarrollo)
   - Ubicación: Selecciona la más cercana

2. **Authentication** (Opcional):
   - Ve a Authentication
   - Habilita "Correo electrónico/contraseña"

3. **Storage** (Opcional):
   - Ve a Storage
   - Clic en "Comenzar"
   - Modo de prueba

#### Paso 5: Configurar Reglas de Seguridad

En Firestore, ve a "Reglas" y usa estas reglas para desarrollo:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura/escritura para desarrollo
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**⚠️ IMPORTANTE:** Estas reglas son solo para desarrollo. En producción, debes implementar reglas de seguridad adecuadas.

#### Paso 6: Ejecutar la App

```bash
# Instalar dependencias (si no lo has hecho)
flutter pub get

# Ejecutar en iOS
flutter run
```

---

## 🔧 Configuración de iOS

### Abrir en Xcode

```bash
open ios/Runner.xcworkspace
```

### Configurar Signing

1. Selecciona el proyecto "Runner" en el navegador
2. Ve a "Signing & Capabilities"
3. Selecciona tu equipo de desarrollo
4. Verifica el Bundle Identifier: `com.falconsoft3d.petcare.petcareApp`

---

## 🎯 Estructura de Datos en Firebase

### Collection: `pets`

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

### Collection: `vaccines`

```json
{
  "id": "uuid",
  "petId": "pet-uuid",
  "name": "Rabia",
  "scheduledDate": "2024-10-12",
  "status": "pending",
  "veterinarianName": "Dr. Sarah Wilson",
  "veterinarianPhoto": "https://...",
  "notes": "Vacuna anual",
  "completedDate": null,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

---

## 🐛 Solución de Problemas

### Error: "Firebase not initialized"

```bash
# Asegúrate de haber ejecutado:
flutterfire configure
```

### Error: "No Firebase App"

Verifica que `firebase_options.dart` existe y está importado en `main.dart`.

### Error de Compilación en iOS

```bash
# Limpiar y reconstruir
cd ios
pod deinstall
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

### Warnings de "withOpacity deprecated"

Estos son solo warnings de estilo y no afectan la funcionalidad. La app funciona perfectamente.

---

## 📱 Comandos Útiles

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en modo release (más rápido)
flutter run --release

# Ver logs en tiempo real
flutter logs

# Limpiar proyecto
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Analizar código
flutter analyze

# Ejecutar tests
flutter test
```

---

## 🎨 Personalización

### Cambiar Colores

Edita `lib/config/theme.dart`:

```dart
static const Color primary = Color(0xFF13EC5B); // Tu color
```

### Cambiar Fuente

En `pubspec.yaml`, cambia:

```yaml
google_fonts: ^6.2.1
```

Y en `theme.dart`:

```dart
GoogleFonts.epilogue() // Cambia a tu fuente
```

---

## 📚 Próximos Pasos

1. ✅ Configurar Firebase
2. ✅ Ejecutar la app
3. 🔄 Implementar autenticación de usuarios
4. 🔄 Agregar carga de fotos
5. 🔄 Implementar notificaciones push
6. 🔄 Agregar pantalla de programador de vacunas completa

---

## 🆘 Soporte

Si tienes problemas:

1. Verifica que Flutter esté actualizado: `flutter doctor`
2. Revisa los logs: `flutter logs`
3. Limpia el proyecto: `flutter clean && flutter pub get`

---

## 📄 Licencia

Desarrollado por Marlon Falcon
© 2024 PetCare App
