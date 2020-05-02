import 'package:location/location.dart';
import 'package:flutter/services.dart';

class GetLocationMethod {
  double lat, long;
  LocationData currentLocation;
  var location = new Location();
  String error;

  // Get Location
  Future getLoc() async {
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      currentLocation = null;
    }
    lat = currentLocation.latitude;
    long = currentLocation.longitude;
    return lat; long;
  }
}
