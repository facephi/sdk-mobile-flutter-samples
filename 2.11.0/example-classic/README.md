# Facephi SdkMobile — Classic Example

Flutter onboarding demo for **Facephi SdkMobile** (`2.11.0`). It wires three plugins end to end: session lifecycle, facial liveness, and ID document capture.

| Plugin | Purpose |
|--------|---------|
| [`fphi_sdkmobile_core`](../2.11.0/fphi_sdkmobile_core) | Session, operation, flows, extra data |
| [`fphi_sdkmobile_selphi`](../2.11.0/fphi_sdkmobile_selphi) | Face capture / passive liveness |
| [`fphi_sdkmobile_selphid`](../2.11.0/fphi_sdkmobile_selphid) | ID document capture + OCR |

Full API reference: [Facephi Flutter Mobile SDK](https://facephi.github.io/sdk-mobile-documentation/docs/flutter/Mobile_SDK).

## Contents

- [Requirements](#requirements)
- [Quick start](#quick-start)
- [Demo UI](#demo-ui)
- [Recommended flow](#recommended-flow)
- [Plugin usage](#plugin-usage)
- [Results](#results)
- [Project layout](#project-layout)
- [Troubleshooting](#troubleshooting)

## Requirements

| Item | Value |
|------|--------|
| Flutter / Dart | Flutter 3.x · Dart `>=2.18.1 <4.0.0` |
| Android | minSdk **24** · JDK **21** · AGP **8.11.1** · Kotlin **2.2.20** |
| iOS | Camera, mic, and location usage strings in `ios/Runner/Info.plist` |
| License | Facephi license URL + platform API keys |

## Quick start

### 1. Credentials & resources

Edit [`lib/license.dart`](lib/license.dart):

```dart
const licenseUrl           = 'https://your-license-host';
const licenseApiKeyAndroid = 'YOUR_ANDROID_KEY';
const licenseApiKeyIOS     = 'YOUR_IOS_KEY';
const customerId           = 'user@example.com';

const resourcesPath        = 'fphi-selphi-widget-resources-sdk.zip';
final resourcesPathSelphid = 'fphi-selphid-widget-resources-sdk.zip';
```

Resource ZIPs must match the package delivered with your Facephi SDK build.

### 2. Dependencies

Path (local monorepo — default in this example):

```yaml
dependencies:
  fphi_sdkmobile_core:
    path: ../2.11.0/fphi_sdkmobile_core
  fphi_sdkmobile_selphi:
    path: ../2.11.0/fphi_sdkmobile_selphi
  fphi_sdkmobile_selphid:
    path: ../2.11.0/fphi_sdkmobile_selphid
```

Hosted (Artifactory):

```yaml
dependencies:
  fphi_sdkmobile_core:
    hosted:
      name: fphi_sdkmobile_core
      url: https://facephicorp.jfrog.io/artifactory/api/pub/pub-pro-fphi/
    version: ^2.11.0
  # same pattern for selphi & selphid
```

### 3. Run

```bash
flutter pub get
flutter run
```

Session starts automatically on launch (`initState` → `launchInitSession`).

## Demo UI

Buttons in [`lib/home.dart`](lib/home.dart):

| Button | Action |
|--------|--------|
| **Init Session** | License + Core session |
| **Init Operation** | Tracking operation (`ONBOARDING`) |
| **Selphi** | Facial / liveness widget |
| **SelphID** | Document capture widget |
| **Get ExtraData** | Extra data + sample backend liveness / matching (after Selphi + SelphID) |
| **Get Flows** | List integration flows |
| **Launch Flow** | Run selected flow (`setSelphiFlow` / `setSelphidFlow` → `startFlow`) |
| **Close Session** | End session and clear UI state |

Wrappers used by the UI:

- [`lib/models/core_widget.dart`](lib/models/core_widget.dart)
- [`lib/models/selphi_face_widget.dart`](lib/models/selphi_face_widget.dart)
- [`lib/models/selphid_widget.dart`](lib/models/selphid_widget.dart)

Launchers: [`lib/providers/`](lib/providers/).

## Recommended flow

**Manual components**

```text
initSession → initOperation → Selphi and/or SelphID → getExtraData → closeSession
```

**Orchestrated flows**

```text
initSession → getFlowIntegrationData → initFlow
           → setSelphiFlow / setSelphidFlow → startFlow → closeSession
```

Always call **`initSession` before** Selphi, SelphID, or flows.

---

## Plugin usage

### fphi_sdkmobile_core

Session lifecycle, tracking, and flow orchestration.

```dart
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_operation_type.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_flow_configuration.dart';

final core = FphiSdkmobileCore();

// Session
final sessionCfg = CoreConfigurationInitSession()
  ..licenseUrl = licenseUrl
  ..licenseApiKey = Platform.isAndroid ? licenseApiKeyAndroid : licenseApiKeyIOS
  ..enableTracking = true;
  // ..enableLocation = true;
  // ..orientation = SdkViewOrientation.portrait;
  // ..internalOptions = {'SKIP_ENV_CHECK': 'true'};

await core.initSession(widgetConfigurationJSON: sessionCfg);

// Operation
await core.initOperation(
  widgetConfigurationJSON: TrackingConfiguration(
    mCustomerId: customerId,
    mType: TrackingOperationType.ONBOARDING,
  ),
);

// Extra data (for backend)
final extra = await core.getExtraData();

// Flows
final flows = await core.getFlowIntegrationData();
await core.initFlow(
  widgetConfigurationJSON: FlowConfiguration(
    mCustomerId: customerId,
    mFlow: selectedFlowId,
  ),
);
await FphiSdkmobileSelphi().setSelphiFlow();
await FphiSdkmobileSelphid().setSelphidFlow();
await core.startFlow();

await core.closeSession();
```

| Method | Purpose |
|--------|---------|
| `initSession` | Start SDK with license |
| `initOperation` | Start tracked operation |
| `getExtraData` | Payload for backend liveness / matching |
| `getSessionId` / `getOperationId` | Session / operation identifiers |
| `getFlowIntegrationData` | Available flows |
| `initFlow` / `startFlow` / `nextStep` / `cancelFlow` | Flow control |
| `closeSession` | End session |

**Message channels** (see [`lib/providers/core.dart`](lib/providers/core.dart)):

| Channel | Role |
|---------|------|
| `core.flow` | Per-step flow results (`SELPHI` / `SELPHID` / …) |
| `tracking.error.listener` | Tracking errors |

---

### fphi_sdkmobile_selphi

Facial capture and liveness.

```dart
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi_configuration.dart';
import 'package:fphi_sdkmobile_selphi/fphi_sdkmobile_selphi_liveness_mode.dart';

final config = SelphiFaceConfiguration()
  ..livenessMode = SelphiFaceLivenessMode.LM_PASSIVE
  ..fullscreen = true
  ..jpgQuality = 0.95
  ..enableGenerateTemplateRaw = true
  ..showTutorial = false;

final result = await FphiSdkmobileSelphi().startSelphiFaceWidget(
  resourcesPath: resourcesPath,
  widgetConfigurationJSON: config,
);
```

| Method | Purpose |
|--------|---------|
| `startSelphiFaceWidget` | Launch Selphi UI |
| `startSignatureSelphiFaceWidget` | Selphi + signature |
| `setSelphiFlow` / `setSignatureSelphiFlow` | Register in a Core flow |
| `generateTemplateRaw` | Template from an image |

Useful config: `livenessMode`, `cameraPreferred`, `compressFormat`, `jpgQuality`, `extractionDuration`, `fullscreen`, `showTutorial`, `params`.

On success, typical keys include `bestImage`, `bestImageCropped`, `templateRaw`, `bestImageTemplateRaw`, `livenessDiagnostic`, `finishStatus`.

---

### fphi_sdkmobile_selphid

ID document capture (sides, face crop, OCR / tokens).

```dart
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_configuration.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_document_type.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_scan_mode.dart';
import 'package:fphi_sdkmobile_selphid/fphi_sdkmobile_selphid_timeout.dart';

final config = SelphIDConfiguration()
  ..documentType = SelphIDDocumentType.DT_IDCARD // Passport, DriverLic, ForeignCard, …
  ..scanMode = SelphIDScanMode.CAP_MODE_SEARCH
  ..specificData = 'AR|<ALL>' // country / document filter
  ..fullscreen = true
  ..wizardMode = true
  ..showResultAfterCapture = true
  ..timeout = SelphIDTimeout.T_SHORT
  ..showDiagnostic = true;

final result = await FphiSdkmobileSelphid().startSelphIDWidget(
  resourcesPath: resourcesPathSelphid,
  widgetConfigurationJSON: config,
);
```

| Method | Purpose |
|--------|---------|
| `startSelphIDWidget` | Launch document UI |
| `setSelphidFlow` | Register in a Core flow |

Enums: `SelphIDDocumentType`, `SelphIDScanMode`, `SelphIDDocumentSide`, `SelphIDTimeout`, `SelphIDCompressFormat`.

On success, typical keys include `frontDocumentImage`, `backDocumentImage`, `faceImage`, `documentData`, `tokenFaceImage`, `tokenOCR`, `matchingSidesScore`, `finishStatus`.

---

## Results

Native calls return a `Map`. This example maps them to typed models:

| Model | File |
|-------|------|
| `CoreResult` | [`lib/models/core_result.dart`](lib/models/core_result.dart) |
| `SelphiFaceResult` | [`lib/models/selphi_face_result.dart`](lib/models/selphi_face_result.dart) |
| `SelphIDResult` | [`lib/models/selphid_result.dart`](lib/models/selphid_result.dart) |

```dart
final r = SelphiFaceResult.fromMap(result);
switch (r.finishStatus) {
  case SdkFinishStatus.STATUS_OK:
    // use r.bestImage, templates, …
    break;
  case SdkFinishStatus.STATUS_ERROR:
    final msg = SdkErrorType.getDiagnosticError(r.errorDiagnostic);
    break;
}
```

After Selphi + SelphID, **Get ExtraData** calls sample Identity Platform endpoints via [`lib/apis/facephi_services.dart`](lib/apis/facephi_services.dart) (passive liveness + facial matching). Wire your own `client-id` / API keys there for a real backend.

## Project layout

```text
lib/
  main.dart / home.dart     # App entry + demo screen
  license.dart              # License URL, API keys, resource paths
  models/                   # Plugin wrappers + result models
  providers/                # UI launchers (core / selphi / selphid)
  apis/facephi_services.dart
  widgets/                  # Preview images, flow picker, buttons
android/                    # AGP 8.11.1 · Kotlin 2.2.20 · Java 21
ios/                        # Pods + Info.plist permissions
```

## Troubleshooting

**`Error resolving plugin … flutter-plugin-loader` / cryptic `> 25.0.2`**  
Android Studio’s bundled JBR may be **Java 25**, which Gradle **8.11.x** does not support. This project pins JDK 21:

```properties
# android/gradle.properties
org.gradle.java.home=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
```

Also:

```bash
flutter config --jdk-dir=/path/to/jdk-21
```

**License / session errors**  
Confirm `licenseUrl` and the correct platform API key in `lib/license.dart`, and that the app id matches the key (Android `applicationId` is `com.facephi.sdk.demo` in this sample).

**Missing resources**  
Ensure Selphi / SelphID ZIP names in `license.dart` match the assets shipped with your native SDK packages.

**iOS permissions**  
`Info.plist` must include camera (and mic / location if tracking or video features need them).
