# Behavior Example (Flutter)

Sample Flutter que integra el plugin [`widget_behavior_flutter`](../../widget_behavior_flutter) (Widget Behavior 360 de Facephi).

Replica el flujo del sample Capacitor: **Login → Home → Dashboard**, con inicialización del SDK, sesión, usuario, posiciones de pantalla y eventos de escritura.

Documentación general del SDK Flutter: [Facephi Mobile SDK](https://facephi.github.io/sdk-mobile-documentation/docs/flutter/Mobile_SDK).

## Requisitos

- Flutter (SDK compatible con el `pubspec.yaml`)
- **JDK 21** para builds Android (el plugin compila a bytecode 21; el JBR 25 de Android Studio no es compatible con Gradle 8.x)
- Licencias Android / iOS en `lib/license.dart`
- Backend demo de sesión: `https://xxx.xxx.com` (usado por `Fip360Service`)

En este repo, Android fuerza el JDK con:

```properties
# android/gradle.properties
org.gradle.java.home=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
```

Ajusta la ruta a tu instalación local de JDK 21 si es necesario.

## Cómo ejecutar

```bash
cd flutter/samples/example-behavior-flutter
flutter pub get
flutter run
```

Build Android debug:

```bash
flutter build apk --debug
```

## Flujo de la app

| Pantalla | Archivo | Behavior |
|----------|---------|----------|
| **Login** | `lib/login.dart` | `initialize` → `setSessionId` → `setPosition('Login')`. Al escribir en el input: `handleTypingEvent`. Al hacer Login: `setUserId` + `setPosition('Home')`. |
| **Home** | `lib/home.dart` | Navegación a Dashboard (`setPosition('Dashboard')`) o Logout (`setPosition('Login')`). |
| **Dashboard** | `lib/dashboard.dart` | Vuelta a Home o Logout con el mismo patrón de posiciones. |

Estado compartido (`sessionId`, `userId`): `lib/services/behavior_service.dart`.

## Estructura relevante

```
lib/
  main.dart                 # Rutas /login, /home, /dashboard
  login.dart / home.dart / dashboard.dart
  license.dart              # licenseKeyAndroid / licenseKeyIOS
  models/behavior_widget.dart   # Wrapper del plugin
  models/behavior_result.dart   # Parseo de finishStatus / errores
  providers/behavior.dart       # launchInitialize, setSessionId, …
  api/fip360_service.dart       # POST /api/init → sessionId
  services/behavior_service.dart
android/app/src/main/java/.../MainApplication.kt  # Bootstrap nativo (obligatorio)
```

## Uso del componente Behavior

El sample no llama al plugin a pelo desde la UI: usa `BehaviorWidget` + helpers en `providers/behavior.dart`.

### 1. Inicializar

```dart
final cfg = WidgetBehaviorConfiguration();
cfg.licenseKey = Platform.isAndroid ? licenseKeyAndroid : licenseKeyIOS;
cfg.enableSupportLogs = true;

final res = await WidgetBehavior().initialize(widgetConfigurationJSON: cfg);
```

En el sample, `launchInitialize()` además:

1. Obtiene un `sessionId` vía `Fip360Service` (`POST https://demobank.fip360.com/api/init`; si falla, genera un UUID).
2. Llama a `setSessionId`.
3. Llama a `setPosition('Login')`.
4. Registra el listener `behavior.events.listener`.

### 2. Sesión y usuario

```dart
await WidgetBehavior().setSessionId(sessionId: sessionId);
await WidgetBehavior().setUserId(userId: userId);
```

### 3. Posición de pantalla

Cada cambio de pantalla relevante debe informar al SDK:

```dart
await WidgetBehavior().setPosition(position: 'Login');     // al iniciar
await WidgetBehavior().setPosition(position: 'Home');      // tras login
await WidgetBehavior().setPosition(position: 'Dashboard'); // al entrar al dashboard
```

### 4. Eventos de escritura (`handleTypingEvent`)

En Login, cada cambio del campo usuario envía un `BehaviorEvent`:

```dart
final event = BehaviorEvent(
  v: value,        // texto actual
  f: 'user',       // fieldType
  t: 'insertText', // inputType
);
await WidgetBehavior().handleTypingEvent(event: event);
```

| Campo | Significado |
|-------|-------------|
| `v` | Valor del input |
| `f` | Tipo de campo (`user`, `email`, …) |
| `t` | Tipo de input (`insertText`, `insertFromPaste`, …) |

### 5. Limpiar sesión

```dart
await WidgetBehavior().clearSessionData();
```

### 6. Listener de eventos nativos

```dart
const channel = BasicMessageChannel<dynamic>(
  'behavior.events.listener',
  StringCodec(),
);
channel.setMessageHandler((message) async {
  // p. ej. AUTO_LOGOUT u otros eventos del SDK
  print(jsonDecode(message!));
  return '';
});
```

### Resultado tipado

Las respuestas del plugin se normalizan con `BehaviorResult`:

- `finishStatus`: `statusOk` (1) / `statusError` (2)
- `errorType` / `errorMessage` si hay error

## Setup de plataforma (imprescindible)

Detalle completo en el [README del plugin](../../widget_behavior_flutter/README.md). Resumen de lo que este sample ya incluye:

### Android — `Application`

El SDK debe arrancar **antes** de usar el plugin Dart:

```kotlin
// android/app/src/main/java/com/example/example/MainApplication.kt
class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        WidgetBehaviorApplication().initializeBehavior(this)
    }
}
```

En `AndroidManifest.xml`:

```xml
<application android:name="MainApplication" ...>
```

### Android — permisos

Declarados en el manifesto del sample (`INTERNET`, ubicación, red, Wi‑Fi, `QUERY_ALL_PACKAGES`, etc.). Menos permisos = menos capacidad de detección; `QUERY_ALL_PACKAGES` es sensible en Play Store.

### iOS — `Info.plist`

Incluye, entre otras:

- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`

## Licencias

Edita `lib/license.dart`:

```dart
const String licenseKeyAndroid = "...";
const String licenseKeyIOS = "...";
```

## Dependencia del plugin

```yaml
# pubspec.yaml
dependencies:
  widget_behavior_flutter:
    path: ../../widget_behavior_flutter
    # o Artifactory:
    # hosted:
    #   name: widget_behavior_flutter
    #   url: https://facephicorp.jfrog.io/artifactory/api/pub/pub-pro-fphi/
    # version: ^2.9.0
```

## API del plugin (referencia rápida)

| Método | Uso en el sample |
|--------|------------------|
| `initialize` | Arranque del widget con licencia |
| `setSessionId` | Tras `/api/init` o UUID local |
| `setUserId` | Al pulsar Login |
| `setPosition` | Login / Home / Dashboard / Logout |
| `handleTypingEvent` | Input de usuario en Login |
| `clearSessionData` | Clear Session en Login |
| `destroy` | (disponible en el plugin; no usado en este sample) |

Para configuración, eventos y tests del plugin, ver [`widget_behavior_flutter/README.md`](../../widget_behavior_flutter/README.md).
