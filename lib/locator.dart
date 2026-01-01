import 'package:get_it/get_it.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
}
