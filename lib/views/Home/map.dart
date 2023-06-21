import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_google_location_picker/flutter_google_location_picker.dart';
import 'package:flutter_google_location_picker/model/lat_lng_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pick extends StatefulWidget {
  const Pick({super.key});

  @override
  State<Pick> createState() => _PickState();
}

class _PickState extends State<Pick> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(40.712776, -74.005974)));
  }
}
