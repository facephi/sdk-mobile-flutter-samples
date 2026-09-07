# Onboarding Example (Selphi IAD + SelphID MBSDR)

Flutter sample for Facephi SdkMobile **2.11.0** using the **IAD** facial component and the **MBSDR** document component.

| Plugin | Role |
|--------|------|
| [`fphi_sdkmobile_core`](../2.11.0/fphi_sdkmobile_core) | Session, operation, flows, extra data |
| [`fphi_sdkmobile_selphi_iad`](../2.11.0/fphi_sdkmobile_selphi_iad) | Facial capture / liveness (Selphi IAD) |
| [`fphi_sdkmobile_selphid_mbsdr`](../2.11.0/fphi_sdkmobile_selphid_mbsdr) | ID document capture (SelphID MBSDR) |

Docs: [Facephi Flutter Mobile SDK](https://facephi.github.io/sdk-mobile-documentation/docs/flutter/Mobile_SDK).

## Requirements

- Flutter 3.x / Dart `>=2.18.1`
- Android: **JDK 17** (or 21), minSdk **24**, AGP **8.11.1**, Kotlin **2.2.20**
- iOS: **15.0+**, CocoaPods with Facephi Artifactory source (`cocoa-dev-fphi`)
- Valid Facephi license (API key + license URL)

> **Android / Java:** Android Studio’s bundled JBR may be Java **25**. Gradle 8.11.x does not support it (cryptic error `> 25.0.2` on `flutter-plugin-loader`). This example sets `org.gradle.java.home` to Homebrew OpenJDK 17 in `android/gradle.properties`. Adjust the path if needed, or pick JDK 17/21 in Android Studio → Gradle JDK.

## Setup

1. Set credentials and resource ZIP names in `lib/license.dart` (`licenseUrl`, `licenseApiKeyAndroid` / `licenseApiKeyIOS`, `resourcesPath`, `resourcesPathSelphid`).
2. Dependencies are wired in `pubspec.yaml` (path or hosted Artifactory):

```yaml
dependencies:
  fphi_sdkmobile_core:
    path: ../2.11.0/fphi_sdkmobile_core
  fphi_sdkmobile_selphi_iad:
    path: ../2.11.0/fphi_sdkmobile_selphi_iad
  fphi_sdkmobile_selphid_mbsdr:
    path: ../2.11.0/fphi_sdkmobile_selphid_mbsdr
```

3. Install and run:

```bash
flutter pub get
cd ios && pod install && cd ..
flutter run
```

## Typical flow

```text
initSession  →  initOperation  →  Selphi / SelphID  →  getExtraData  →  closeSession
```

Optional flow orchestration:

```text
getFlowIntegrationData  →  initFlow  →  setSelphiFlow / setSelphidFlow  →  startFlow
```

UI buttons live in `lib/home.dart`. Plugin wrappers:

- `lib/models/core_widget.dart`
- `lib/models/selphi_face_widget.dart`
- `lib/models/selphid_widget.dart`

Providers: `lib/providers/core.dart`, `selphi.dart`, `selphid.dart`.

---

## fphi_sdkmobile_core

Session lifecycle and tracking. Wrapper: `CoreWidget`.

### Init session

```dart
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_core_configuration.dart';

final cfg = CoreConfigurationInitSession()
  ..licenseUrl = licenseUrl
  ..licenseApiKey = licenseApiKeyAndroid // or iOS
  ..enableTracking = true;

final result = await FphiSdkmobileCore().initSession(
  widgetConfigurationJSON: cfg,
);
```

### Init operation

```dart
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_configuration.dart';
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_tracking_operation_type.dart';

await FphiSdkmobileCore().initOperation(
  widgetConfigurationJSON: TrackingConfiguration(
    mCustomerId: customerId,
    mType: TrackingOperationType.ONBOARDING,
  ),
);
```

### Extra data (after Selphi + SelphID)

```dart
final result = await FphiSdkmobileCore().getExtraData();
// Use result['data'] with backend liveness / facial matching APIs
```

### Close session

```dart
await FphiSdkmobileCore().closeSession();
```

### Flows

```dart
import 'package:fphi_sdkmobile_core/fphi_sdkmobile_flow_configuration.dart';

final flows = await FphiSdkmobileCore().getFlowIntegrationData();

await FphiSdkmobileCore().initFlow(
  widgetConfigurationJSON: FlowConfiguration(
    mCustomerId: customerId,
    mFlow: selectedFlowId,
  ),
);

await FphiSdkmobileSelphi().setSelphiFlow();
await FphiSdkmobileSelphid().setSelphidFlow();
await FphiSdkmobileCore().startFlow();
```

Step results arrive on `BasicMessageChannel` `core.flow` (see `launchFlow` in `lib/providers/core.dart`). Tracking errors use `tracking.error.listener`.

### Main Core API

| Method | Purpose |
|--------|---------|
| `initSession` | Start SDK session with license |
| `initOperation` | Start tracked operation |
| `getExtraData` | Token / payload for backend checks |
| `closeSession` | End session |
| `getFlowIntegrationData` | List available flows |
| `initFlow` / `startFlow` / `nextStep` / `cancelFlow` | Flow orchestration |

---

## fphi_sdkmobile_selphi_iad

Passive (or active) face capture and liveness with **IAD**. Wrapper: `SelphiFaceWidget`.

```dart
import 'package:fphi_sdkmobile_selphi_iad/fphi_sdkmobile_selphi.dart';
import 'package:fphi_sdkmobile_selphi_iad/fphi_sdkmobile_selphi_configuration.dart';
import 'package:fphi_sdkmobile_selphi_iad/fphi_sdkmobile_selphi_liveness_mode.dart';

final config = SelphiFaceConfiguration()
  ..livenessMode = SelphiFaceLivenessMode.LM_PASSIVE
  ..fullscreen = true
  ..jpgQuality = 0.95
  ..enableGenerateTemplateRaw = true
  ..showTutorial = false;

final result = await FphiSdkmobileSelphi().startSelphiFaceWidget(
  resourcesPath: 'fphi-selphi-widget-resources-sdk.zip',
  widgetConfigurationJSON: config,
);
```

Register inside a Core flow:

```dart
await FphiSdkmobileSelphi().setSelphiFlow();
```

### Main Selphi API

| Method | Purpose |
|--------|---------|
| `startSelphiFaceWidget` | Launch facial / liveness UI |
| `startSignatureSelphiFaceWidget` | Selphi with signature |
| `setSelphiFlow` / `setSignatureSelphiFlow` | Register component in a flow |
| `generateTemplateRaw` | Build template from an image |

Useful config: `livenessMode`, `cameraPreferred`, `compressFormat`, `jpgQuality`, `extractionDuration`, `fullscreen`, `showTutorial`.

---

## fphi_sdkmobile_selphid_mbsdr

ID document capture (front / back / face crop + OCR) via **MBSDR**. Wrapper: `SelphIDWidget`.

```dart
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_configuration.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_document_type.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_scan_mode.dart';
import 'package:fphi_sdkmobile_selphid_mbsdr/fphi_sdkmobile_selphid_timeout.dart';

final config = SelphIDConfiguration()
  ..documentType = SelphIDDocumentType.DT_IDCARD
  ..scanMode = SelphIDScanMode.CAP_MODE_SEARCH
  ..specificData = 'AR|<ALL>'
  ..fullscreen = true
  ..wizardMode = true
  ..showResultAfterCapture = true
  ..timeout = SelphIDTimeout.T_SHORT
  ..showDiagnostic = true;

final result = await FphiSdkmobileSelphid().startSelphIDWidget(
  resourcesPath: 'fphi-selphid-widget-resources-sdk.zip',
  widgetConfigurationJSON: config,
);

// On success (Android): front/back/face images, documentData, tokens,
// optional encodedDataImages / tokenEncodedDataImages, finishStatus, …
```

Register inside a Core flow:

```dart
await FphiSdkmobileSelphid().setSelphidFlow();
```

### Main SelphID API

| Method | Purpose |
|--------|---------|
| `startSelphIDWidget` | Launch document capture UI |
| `setSelphidFlow` | Register component in a flow |

Useful enums: `SelphIDDocumentType`, `SelphIDScanMode`, `SelphIDDocumentSide`, `SelphIDTimeout`, `SelphIDCompressFormat`.

### Extra image payloads (`encodedDataImages` / `tokenEncodedDataImages`)

When the native SDK returns extra encoded sides (Android), the plugin exposes them as optional **lists of maps** on the result (parsed in `SelphIDResult`):

| Key | Shape | Item fields |
|-----|--------|-------------|
| `encodedDataImages` | `List<Map>` | `image`, `side`, `format` |
| `tokenEncodedDataImages` | `List<Map>` | `token`, `side`, `format` |

Example:

```dart
final selphId = SelphIDResult.fromMap(result);

for (final item in selphId.encodedDataImages ?? const []) {
  final image = item['image'] as String?;   // base64
  final side = item['side'] as String?;     // FRONT / BACK / …
  final format = item['format'] as String?; // QR / PDF417 / …
}

for (final item in selphId.tokenEncodedDataImages ?? const []) {
  final token = item['token'] as String?;
  final side = item['side'] as String?;
  final format = item['format'] as String?;
}
```

If the SDK returns no extra images, these keys are **omitted** and `fromMap` sets them to `null` (do not treat them as `String` or as a single `Map` of parallel lists).

---

## Handling results

Native calls return a `Map`. This example maps them with:

- `CoreResult` — `lib/models/core_result.dart`
- `SelphiFaceResult` — `lib/models/selphi_face_result.dart`
- `SelphIDResult` — `lib/models/selphid_result.dart` (optional `List<Map>` for `encodedDataImages` / `tokenEncodedDataImages`)

Check `finishStatus` (`SdkFinishStatus.STATUS_OK` / `STATUS_ERROR`) and surface `errorDiagnostic` when needed.

Sample backend calls (liveness / matching) live in `lib/apis/facephi_services.dart`.

## Project layout

```text
lib/
  home.dart                   # Demo UI buttons
  license.dart                # License URL, API keys, resource paths
  models/                     # Plugin wrappers + result models
  providers/                  # Async launchers wired to the UI
  widgets/                    # Buttons, image previews, flow sheet
  apis/facephi_services.dart  # Sample backend calls
android/                      # AGP 8.11.1 + JDK 17 sample config
ios/                          # CocoaPods (Facephi Artifactory + CDN)
```

## Notes

- Call **`initSession` before** Selphi / SelphID.
- Resource ZIPs (`fphi-selphi-widget-resources-sdk.zip`, `fphi-selphid-widget-resources-sdk.zip`) must be available as in your Facephi package delivery.
- iOS needs camera (and related) usage strings in `Info.plist`; Podfile uses `platform :ios, '15.0'` and `cocoapods-art` source `cocoa-dev-fphi`.
- Differs from `example-classic`: uses **`selphi_iad`** and **`selphid_mbsdr`** instead of the standard Selphi / SelphID plugins.
