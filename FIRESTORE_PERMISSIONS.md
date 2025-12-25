# 🔥 Error de Permisos de Firestore - Solución

## ❌ Error Actual

```
[cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.
```

## ✅ Solución

### Paso 1: Ir a Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto **FFdemo**
3. En el menú lateral, clic en **Firestore Database**
4. Clic en la pestaña **Reglas** (Rules)

### Paso 2: Actualizar las Reglas

Reemplaza las reglas actuales con estas (para desarrollo):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura y escritura a todos (SOLO PARA DESARROLLO)
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

### Paso 3: Publicar

1. Clic en **Publicar** (Publish)
2. Espera a que se apliquen los cambios (unos segundos)

---

## 🔒 Reglas para Producción (Opcional)

Cuando estés listo para producción, usa estas reglas más seguras:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Regla para mascotas
    match /pets/{petId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null 
                             && resource.data.ownerId == request.auth.uid;
    }
    
    // Regla para vacunas
    match /vaccines/{vaccineId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null;
    }
  }
}
```

---

## 🔥 Reglas de Storage

También actualiza las reglas de Storage:

1. En Firebase Console, ve a **Storage**
2. Clic en **Reglas** (Rules)
3. Usa estas reglas:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /pet_photos/{imageId} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.resource.size < 5 * 1024 * 1024
                   && request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## ✅ Verificar

Después de actualizar las reglas:

1. Ejecuta la app de nuevo: `flutter run`
2. Intenta añadir una mascota
3. Debería funcionar sin errores de permisos

---

**¡Importante!**: Las reglas con `if true` son solo para desarrollo. En producción, usa reglas más restrictivas.
