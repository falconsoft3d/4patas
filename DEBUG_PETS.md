# 🔍 Depuración - Mascotas No Aparecen

## Pasos para Depurar

### 1. Verificar en Firebase Console

1. Ve a [Firestore Console](https://console.firebase.google.com/project/f-fdemo-ikag1q/firestore/data)
2. Busca la colección `pets`
3. Verifica si hay documentos ahí
4. Anota el valor del campo `ownerId` de cada mascota

### 2. Verificar el Usuario Actual

En la app, cuando estés en el dashboard:
- Si estás logueado, el `ownerId` debería ser tu Firebase UID
- Si NO estás logueado, el `ownerId` debería ser `"guest"`

### 3. Verificar Logs en la Consola

Busca en los logs de Flutter (terminal) mensajes como:
- `Error adding pet: ...`
- `Error getting pet: ...`

### 4. Prueba Manual

1. **Cierra la app completamente** (no solo hot reload)
2. **Ejecuta de nuevo**:
   ```bash
   flutter run
   ```
3. **Inicia sesión** (importante)
4. **Añade una mascota**
5. **Verifica que aparezca**

### 5. Si Aún No Funciona

Ejecuta esto en el terminal:

```bash
# Ver todos los documentos en Firestore
firebase firestore:get pets --project f-fdemo-ikag1q
```

O manualmente en Firebase Console:
1. Firestore Database
2. Colección `pets`
3. Verifica los documentos

### 6. Verificar Índices

Si ves un error sobre índices:
1. Firebase Console → Firestore → Índices
2. Verifica si hay índices pendientes
3. Clic en el enlace del error para crear el índice automáticamente

---

## Posibles Causas

1. **No estás logueado**: Las mascotas se guardan con un `ownerId` diferente
2. **Índice faltante**: Firestore necesita un índice compuesto (ya lo arreglé)
3. **Permisos**: Las reglas no permiten leer (ya lo arreglamos)
4. **Cache**: La app tiene datos en caché

---

## Solución Rápida

```bash
# Detén la app
Ctrl + C

# Limpia todo
flutter clean

# Reinstala dependencias
flutter pub get

# Ejecuta de nuevo
flutter run
```

---

## Verificación Final

Después de añadir una mascota, verifica en Firebase Console que:
- ✅ El documento existe en `pets`
- ✅ El `ownerId` coincide con tu usuario
- ✅ Todos los campos están presentes
