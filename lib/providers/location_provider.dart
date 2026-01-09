import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _service;

  LocationProvider(this._service);

  bool loading = false;
  String? country;
  String? error;

  Future<void> fetchLocation() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      country = await _service.getCountry();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
