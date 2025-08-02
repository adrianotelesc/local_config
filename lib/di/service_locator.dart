import 'package:local_config/repository/config_repository.dart';
import 'package:local_config/repository/dummy_config_repository.dart';

abstract final class ServiceLocator {
  static final _dummies = <Type, Object>{
    ConfigRepository: DummyConfigRepository()
  };
  static final _instances = <Type, Object>{};

  static void register<T extends Object>(T instance) {
    _instances[T] = instance;
  }

  static T get<T>() {
    final instance = _instances[T] ?? _dummies[T];

    return instance as T;
  }

  static void reset() {
    _instances.clear();
  }
}
