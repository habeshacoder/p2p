import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:p2p/models/order.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Utilities {
  //google map api key
  static final String googleMapApi = "AIzaSyCJc75czqiuE1L-bq8WUYyZr0pR2kMt-m0";

  static String? validatePhoneNumber(String value) {
    // Remove non-numeric characters from the phone number
    String numericValue = value;
    if (numericValue.isEmpty) {
      return "Please input phone number";
    }
    // Check if the numeric value is 13 digits long
    if (numericValue.length != 13) {
      return 'Phone number must be 13 digits long';
    }
    // Check if the numeric value starts with "+251" (Ethiopian country code)
    if (!numericValue.startsWith('+251')) {
      return 'Phone number must start with +251';
    }
    // If all conditions pass, the phone number is valid
    return null;
  }

  static String? validatePassword(String value) {
    // Remove non-numeric characters from the phone number
    String numericValue = value;
    if (numericValue.isEmpty) {
      return "Please insert password";
    }
    // Check if the numeric value is 13 digits long
    if (numericValue.length < 6) {
      return 'Password must be 6 digit and above';
    }
    // If all conditions pass, the phone number is valid
    return null;
  }

  static bool validateEmail(String email) {
    // Regular expression pattern for validating email
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  static Future<LatLng> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Handle the case where the user does not enable the location service.
        return const LatLng(9.1450, 38.7250); //default location.
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Handle the case where the user denies the location permission.
        return const LatLng(9.1450,
            38.8250); // Default to (0, 0) if location permission is not granted.
      }
    }

    locationData = await location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  //get address from latlong value
  Future<Point?> reverseGeocode(String? latLngString, String? street) async {
    LatLng latLng = parseLatLng(latLngString!);

    final apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleMapApi';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("response body of mapapi${response.body}");
      print("response of mapapi after decode:${json.decode(response.body)}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = json.decode(response.body);
        final results = decodedData['results'] as List<dynamic>;
        if (results.isEmpty) {
          throw Exception('failed to get Address information');
        }
        print("result:$results");
        final addressComponents =
            results[0]['address_components'] as List<dynamic>;

        return Point(
          id: null,
          latitude: decodedData["results"][0]["geometry"]["location"]["lat"] ??
              latLng.latitude,
          longitude: decodedData["results"][0]["geometry"]["location"]["lat"] ??
              latLng.longitude,
          street: street ?? null,
          city: decodedData["results"][1]["address_components"][1]
                  ["short_name"] ??
              null,
          country: decodedData["results"][0]["formatted_address"] ?? null,
          remark: null,
          createdOn: DateTime.now(),
          updatedOn: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('failed to fetch Address');
    }

    // Default values if reverse geocoding fails
  }

  LatLng parseLatLng(String latLngString) {
    String locationValueString =
        latLngString.replaceAll("LatLng(", "").replaceAll(")", "");
    // Split the string into latitude and longitude values
    List<String> values = locationValueString.split(", ");
    double latitude = double.parse(values[0]);
    double longitude = double.parse(values[1]);

    return LatLng(latitude, longitude);
  }

  static String? getVehicleImage(String? vehicleType) {
    switch (vehicleType) {
      case 'PICKUP_TRUCK':
        return 'assets/images/vehicle_images/truck.png';
      case 'CARGO_VAN':
        return 'assets/images/vehicle_images/cargo.png';
      case 'BOX_TRUCK':
        return 'assets/images/vehicle_images/box.png';
      case 'COURIER':
        return 'assets/images/vehicle_images/courier.png';
      case 'MOTOR_BIKE':
        return 'assets/images/vehicle_images/motor.png';
      case 'BIKE':
        return 'assets/images/vehicle_images/bicycle.jpg';
      default:
        return null;
    }
  }
}
