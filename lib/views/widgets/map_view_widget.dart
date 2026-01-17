import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../../constants/map_constants.dart';

class MapViewWidget extends StatelessWidget {
  final Function(MapLibreMapController) onMapCreated;

  const MapViewWidget({super.key, required this.onMapCreated});

  @override
  Widget build(BuildContext context) {
    return MapLibreMap(
      styleString: MapConstants.mapStyle,
      myLocationEnabled: true,
      initialCameraPosition: const CameraPosition(
        target: LatLng(10.77, 106.69),
        zoom: 12,
      ),
      onMapCreated: onMapCreated,
    );
  }
}