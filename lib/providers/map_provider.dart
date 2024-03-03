import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import the LatLng class

class MapProvider extends ChangeNotifier {
  LatLng? _latLngDrop;
  LatLng? _latLngPick;

  LatLng? get pickup => _latLngPick; // Rename the getter method
  LatLng? get dropoff => _latLngDrop; // Rename the getter method

  void setPickup(LatLng latlng) {
    _latLngPick = latlng;
    notifyListeners();
  }

  void setDropoff(LatLng latlng) {
    _latLngDrop = latlng;
    notifyListeners();
  }
}
