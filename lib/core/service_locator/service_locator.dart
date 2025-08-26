abstract class ServiceLocator {
  void registerLazySingleton<T extends Object>(T Function() factory);

  void registerFactory<T extends Object>(T Function() factory);

  void unregister<T extends Object>();

  T locate<T extends Object>();
}
