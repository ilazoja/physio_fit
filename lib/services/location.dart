import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';

StreamSubscription<Position> geoSub;
bool locationSet = false;
bool locationPermissionSet = false;

const String kGoogleApiKey = 'AIzaSyDT4jcZc6RgmHdx_y6JTC4mEhRgkE-3jc4';
GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
List<double> currentLocationPoint = <double>[];

Future<void> initLocationServices() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (locationSet == false) {
    const LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geoSub = Geolocator()
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      if (position != null) {
        prefs.setString('lat', position.latitude.toString());
        prefs.setString('long', position.longitude.toString());
        currentLocationPoint.add(position.latitude);
        currentLocationPoint.add(position.longitude);

        locationSet = true;
      }
    });
  }
}

Future<bool> getLocationPermissionStatus() async {
  final GeolocationStatus status =
      await Geolocator().checkGeolocationPermissionStatus();
  if (status != GeolocationStatus.granted) {
    locationPermissionSet = false;
  } else {
    locationPermissionSet = true;
  }

  return locationPermissionSet;
}
