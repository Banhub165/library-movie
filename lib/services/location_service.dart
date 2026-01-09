/// lib/services/location_service.dart
import 'package:flutter/foundation.dart';

class LocationService {
  Future<String> getCountry() async {
    // 🔒 WEB SAFE IMPLEMENTATION
    if (kIsWeb) {
      await Future.delayed(const Duration(seconds: 1));
      return 'Indonesia (Web)';
    }

    // Mobile / Desktop (nanti bisa diaktifkan lagi)
    throw Exception('Location not supported on this platform');
  }
}
