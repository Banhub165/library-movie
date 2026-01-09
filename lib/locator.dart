import 'package:get_it/get_it.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'services/location_service.dart';
import 'providers/location_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerFactory<LocationProvider>(() => LocationProvider(locator()));
}
