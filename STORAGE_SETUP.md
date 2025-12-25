# 🔥 Error de Firebase Storage - Solución

## ❌ Error Actual

```
Error al subir imagen: [firebase_storage/object-not-found] No object exists at the desired reference.
```

## ✅ Solución: Habilitar Firebase Storage

### Paso 1: Ir a Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto **FFdemo**
3. En el menú lateral, clic en **Storage**

### Paso 2: Habilitar Storage

1. Clic en **Comenzar** (Get Started)
2. Aparecerá un diálogo sobre reglas de seguridad
3. Selecciona **Modo de prueba** (Test mode)
4. Clic en **Siguiente**
5. Selecciona una ubicación (ej: `us-central1`)
6. Clic en **Listo**

### Paso 3: Actualizar Reglas de Storage

Una vez habilitado Storage:

1. Ve a la pestaña **Reglas** (Rules)
2. Reemplaza las reglas con esto (para desarrollo):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if true;
    }
  }
}
```

3. Clic en **Publicar** (Publish)

---

## 🔒 Reglas para Producción (Opcional)

Cuando estés listo para producción, usa estas reglas más seguras:

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

Después de habilitar Storage:

1. **Reinicia la app**: Presiona `R` en el terminal
2. **Intenta subir una imagen** de nuevo
3. **Debería funcionar** sin errores

---

## 📝 Nota Importante

**Storage debe estar habilitado en Firebase Console** antes de poder subir archivos. No se puede hacer desde CLI si no está habilitado primero.

---

## 🔗 Enlaces Útiles

- [Storage Console](https://console.firebase.google.com/project/f-fdemo-ikag1q/storage)
- [Documentación de Storage](https://firebase.google.com/docs/storage)
