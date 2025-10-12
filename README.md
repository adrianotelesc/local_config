# Local Config

> 🧩 A Flutter package for managing **local configs** — just like Remote Config, but offline.

---

## ✨ Features

- Manage app configuration values locally  
- Use a familiar API inspired by **Firebase Remote Config**  
- Easily initialize from a simple `Map`.
- Access configs at runtime anywhere in your app  
- Built-in entrypoint screen for viewing/editing local configs  

---

## 🚀 Getting Started

### Initialization

#### Initialize with your values

```dart
import 'package:flutter/material.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalConfig.instance.initialize(
    defaults: {
        'feature_home_banner_enabled': 'true',
        'api_base_url': 'https://api.myapp.com/v1',
        'retry_attempts': '3',
        'welcome_message': 'Welcome to MyApp!',
        'theme': '{"primaryColor": "#2196F3", "darkMode": false}',
    },
  );

  runApp(const YourApp());
}
```

#### Initialize with Remote Config values

```dart
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseRemoteConfig.instance.fetchAndActivate();

  await LocalConfig.instance.initialize(
    defaults: FirebaseRemoteConfig.instance.getAll().map(
      (key, value) => MapEntry(key, value.asString()),
    ),
  );

  runApp(const YourApp());
}
```

---

### Navigating to the Built-in Config Screen

```dart
FilledButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocalConfig.instance.entrypoint,
      ),
    );
  },
  child: const Text('Go to Local Config'),
)
```

---

## 💡 Usage Example

You can access your config values anywhere after initialization:

```dart
final message = LocalConfig.instance.getString('config_string');
final delay = LocalConfig.instance.getInt('config_number');
final enabled = LocalConfig.instance.getBool('config_boolean');
final json = LocalConfig.instance.getJson('config_json');
```

Or listen to changes (if your implementation supports it):

```dart
LocalConfig.instance.stream.listen((configs) {
  print('Configs updated: $configs');
});
```

For a full demo, check the `/example` folder.

---

## 🧠 Why Local Config?

Use this package when you:
- Want to replicate Remote Config behavior **without needing a backend**  
- Need **local overrides** for testing or staging  
- Prefer to keep configuration values bundled with the app  

---

## 📦 Additional Information

- 🐛 Report issues or request features in the [GitHub Issues](https://github.com/yourusername/local_config/issues)  
- 💬 Contributions are welcome! Feel free to open pull requests.  
- 🧾 Licensed under MIT  
