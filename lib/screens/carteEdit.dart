import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/plante.dart';
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

  Widget planteMarker({
    required String imagePath,
  }) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/marker.png',
            width: 90,
            height: 90,
          ),

          Positioned(
            top: 9,
            child: ClipOval(
              child: imagePath == 'assets/default.png'
                ? Image.asset('assets/default.png', width: 25, height: 25, fit: BoxFit.cover)
                : Image.file(File(imagePath), width: 25, height: 25, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
