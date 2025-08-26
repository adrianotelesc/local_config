import 'package:get_it/get_it.dart';
import 'package:local_config/core/service_locator/service_locator.dart';

class GetItServiceLocator implements ServiceLocator {
  @override
  void registerFactory<T extends Object>(T Function() factory) {
    GetIt.I.registerFactory<T>(factory);
  }

  @override
  void registerLazySingleton<T extends Object>(T Function() factory) {
    GetIt.I.registerLazySingleton<T>(factory);
  }

  @override
  void unregister<T extends Object>() {
    GetIt.I.unregister<T>();
  }

  @override
  T locate<T extends Object>() => GetIt.I.get<T>();
}
