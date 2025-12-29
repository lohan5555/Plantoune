import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/plante.dart';
import '../models/planteMarker.dart';
import '../services/positionService.dart';

class CarteEditPage extends StatefulWidget {
  const CarteEditPage({
    super.key,
    required this.initialPosition,
    required this.plante
  });

  final LatLng initialPosition;
  final Plante plante;

  @override
  State<CarteEditPage> createState() => _CarteEditPageState();
}

class _CarteEditPageState extends State<CarteEditPage>{
  final PositionService positionService = PositionService();
  final MapController _mapController = MapController();

  LatLng? newLocalisation;

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
              initialZoom: 15,
              maxZoom: 18,
              onTap: (tapPosition, latLng){
                setState(() {
                  newLocalisation = latLng;
                });
              }
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
                    ? []
                    : [
                  Marker(
                    point: newLocalisation!,
                    width: 100,
                    height: 100,
                    child: planteMarker(
                      imagePath: widget.plante.imagePath ?? 'assets/default.png',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.move(widget.initialPosition,15),
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
