import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  LocationProvider(this._locationService);

  String _country = 'Detecting...';
  bool _loading = true;

  String get country => _country;
  bool get loading => _loading;

  Future<void> fetchLocation() async {
    _loading = true;
    notifyListeners();

    try {
      _country = await _locationService.getCountry();
    } catch (e) {
      _country = 'Location Error';
    }

    _loading = false;
    notifyListeners();
  }
}
