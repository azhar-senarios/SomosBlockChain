import 'all_utills.dart';

final _locator = GetIt.instance;

IStorage get storage => _locator<PrefsStorage>();
AuthRepository get authRepository => _locator<AuthRepository>();
HomeRepository get homeRepository => _locator<HomeRepository>();

abstract class DependencyInjectionEnvironment {
  static Future<void> setup() async {
    _locator.registerLazySingleton<PrefsStorage>(() => PrefsStorage());
    _locator.registerLazySingleton<HomeRepository>(() => HomeRepository());
    _locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
    await storage.init();
  }
}
