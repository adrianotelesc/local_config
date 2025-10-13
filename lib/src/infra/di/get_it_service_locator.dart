import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:local_config/src/core/di/service_locator.dart';

class GetItServiceLocator implements ServiceLocator {
  @override
  T get<T extends Object>() => GetIt.I.get<T>();

  @override
  void registerFactory<T extends Object>(T Function() factory) =>
      GetIt.I.registerFactory<T>(factory);

  @override
  void registerLazySingleton<T extends Object>(T Function() factory) =>
      GetIt.I.registerLazySingleton<T>(factory);

  @override
  FutureOr<dynamic> unregister<T extends Object>() => GetIt.I.unregister<T>();
}
