import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mapPref.dart';
import '../data/models/planteMarker.dart';
import '../services/positionService.dart';

class CarteAjoutPage extends StatefulWidget {
  const CarteAjoutPage({
    super.key,
    required this.initialPosition,
  });

  final LatLng initialPosition;

  @override
  State<CarteAjoutPage> createState() => _CarteAjoutPageState();
}

class _CarteAjoutPageState extends State<CarteAjoutPage>{
  final PositionService positionService = PositionService();
  final MapController _mapController = MapController();
  double currentZoom = 10;

  LatLng? newLocalisation;

  @override
  void initState() {
    super.initState();
    _setCurrentZoom();
  }


  void _setCurrentZoom() async{
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(MapPref.zoom)) {
      final val = prefs.getDouble(MapPref.zoom);
      if (val != null) {
        setState(() {
          currentZoom = val;
        });
      }
      _mapController.move(widget.initialPosition, currentZoom);
    }
  }

  void _updateZoom() {
    MapPref.saveZoomValue(currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {Navigator.pop(context, newLocalisation);},
              icon: Icon(Icons.check)
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialPosition,
              initialZoom: currentZoom,
              maxZoom: 18,
              onTap: (tapPosition, latLng){
                setState(() {
                  newLocalisation = latLng;
                });
              },
              onPositionChanged: (position, hasGesture){
                setState(() {
                  currentZoom = position.zoom;
                });
                _updateZoom();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.plantoune',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
              MarkerLayer(
                markers: newLocalisation == null
                    ? [
                  Marker(
                    point: widget.initialPosition,
                    width: 100,
                    height: 100,
                    child: planteMarker(
                      imagePath: 'assets/default.png',
                    ),
                  ),
                ]
                    : [
                  Marker(
                    point: newLocalisation!,
                    width: 100,
                    height: 100,
                    child: planteMarker(
                      imagePath: 'assets/default.png',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.move(widget.initialPosition,currentZoom),
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
