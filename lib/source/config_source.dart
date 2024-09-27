abstract class ConfigSource {
  Future<void> initialize();

  bool? getBool(String key);

  int? getInt(String key);

  double? getDouble(String key);

  String? getString(String key);

  Future<void> setBool(String key, bool value);

  Future<void> setInt(String key, int value);

  Future<void> setDouble(String key, double value);

  Future<void> setString(String key, String value);
}
