import 'dart:ui';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';

Future<loc.LocationData?> getUserLocation() async {
  //call this async method from whereever you need

  loc.LocationData? myLocation;
  String error = "error";
  // Position? position;
  loc.Location location = loc.Location();
  // Future<Position?> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return null;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return null;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return null;
  //   }
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best);
  // }

  // // position = await _determinePosition();
  try {
    myLocation = await location.getLocation();
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      error = 'please grant permission';
      print(error);
      return null;
    }
    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      error = 'permission denied- please enable it from app settings';
      print(error);
      return null;
    }
  }
  if (myLocation == null) {
    return null;
  } else {
    String first;

    return myLocation;
  }
}
