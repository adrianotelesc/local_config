<p align="center">
    <a href="https://github.com/adrianotelesc/local-config-flutter" align="center">
        <img alt="Local Config" src="https://raw.githubusercontent.com/adrianotelesc/local-config-flutter/main/doc/images/banner.png" />
    </a>
</p>

<p align="center">
  <a href="https://pub.dev/packages/local_config"><img src="https://img.shields.io/pub/v/local_config.svg" alt="Pub"></a>
  <a href="https://github.com/adrianotelesc/local-config-flutter/actions/workflows/ci.yml"><img src="https://github.com/adrianotelesc/local-config-flutter/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://codecov.io/gh/adrianotelesc/local-config-flutter"><img src="https://codecov.io/gh/adrianotelesc/local-config-flutter/graph/badge.svg?token=SM8RpYH49p"/></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
</p>

Make changes to your app's default behavior and appearance by changing parameter values — just like Firebase Remote Config, but locally. It’s designed for teams that need flexibility to override parameters, test feature flags, and simulate Remote Config behavior directly on their devices.

---

## Features

The main goal is to provide the ability to manage configs locally for any purpose during development, testing, and even staging workflows.

- Familiar API inspired by **Firebase Remote Config** (`onConfigUpdated`, `getBool`, `getString`, etc)
- Built-in widget, also inspired by **Firebase Remote Config**, for viewing/editing parameter values
- Persistent parameter value overrides using [`shared_preferences`](https://pub.dev/packages/shared_preferences) or [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)

---

## Getting Started

#### Add dependency

```yaml
dependencies:
  local_config: ^0.2.2
```

#### Initialize with your parameters

```dart
import 'package:flutter/material.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalConfig.instance.initialize(
    params: {
      'social_login_enabled': false,
      'timeout_ms': 8000,
      'animation_speed': 1.25,
      'api_base_url': 'https://api.myapp.com/v1',
      "checkout": {
        "payment_methods": {
          "allowed": ["credit_card", "pix", "boleto"],
          "default": "credit_card",
        },
        "installments": {
          "enabled": false,
          "rules": [
            {"max_installments": 3, "min_order_value": 0},
            {"max_installments": 6, "min_order_value": 100},
            {"max_installments": 10, "min_order_value": 300},
          ],
        },
      },
    },
  );

  runApp(const ExampleApp());
}
```

#### Or with the `FirebaseRemoteConfig` parameters

```dart
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseRemoteConfig.instance.fetchAndActivate();

  await LocalConfig.instance.initialize(
    params: FirebaseRemoteConfig.instance.getAll().map(
      (key, value) => MapEntry(key, value.asString()),
    ),
  );

  runApp(const ExampleApp());
}

```
> **⚠️ Warning**: When using [`RemoteConfigValue.asString()`](https://pub.dev/documentation/firebase_remote_config/latest/firebase_remote_config/RemoteConfigValue/asString.html) from Firebase Remote Config, the returned value may not always match the expected logical type. For example, booleans can sometimes come as numeric strings ("0" or "1") instead of "true" or "false".

#### Navigate to built-in entrypoint widget

```dart
IconButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocalConfigEntrypoint(),
      ),
    );
  },
  tooltip: 'Local Config',
  icon: const Icon(Icons.settings),
)
```

#### Get parameter values

```dart
final socialLoginEnabled = LocalConfig.instance.getBool('social_login_enabled');
final timeoutMs = LocalConfig.instance.getInt('timeout_ms');
final animatinoSpeed = LocalConfig.instance.getDouble('animation_speed');
final apiBaseUrl = LocalConfig.instance.getString('api_base_url');
final checkout = LocalConfig.instance.getString('checkout');
```

#### Or listen for updates (if your implementation supports it)

```dart
LocalConfig.instance.onConfigUpdated.listen((configs) {
  print('Configs updated: $configs');
});
```

For a full demo, check the [`example`](https://github.com/adrianotelesc/local-config-flutter/tree/main/example/lib/main.dart) folder.

---

## Additional Information

- Report issues or request features in the [GitHub Issues](https://github.com/adrianotelesc/local-config-flutter/issues)  
- Contributions are welcome! Feel free to open pull requests.
