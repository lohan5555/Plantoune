import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/plante.dart';
import '../services/positionService.dart';
import 'detailPlante.dart';

class CartePage extends StatefulWidget {
  const CartePage({
    super.key,
    required this.plantes,
    required this.positionService
  });

  final List<Plante> plantes;
  final PositionService positionService;

  @override
  State<CartePage> createState() => _CartePageState();
}

class _CartePageState extends State<CartePage>{
  final MapController _mapController = MapController();
  LatLng currentLocalisation = LatLng(45.066669, 5.93333);

  @override
  void initState() {
    super.initState();
    _setCurrentCoordonnees();
  }

  void _setCurrentCoordonnees() async{
    Position? p = await widget.positionService.getCurrentPosition();
    if(p != null){
      final userLatLng = LatLng(p.latitude, p.longitude);
      setState(() {
        currentLocalisation = userLatLng;
      });
      _mapController.move(userLatLng, 15);
    }
  }



  //créer une liste de marker à partir de la liste des plantes
  List<Marker> listMarker(List<Plante> plantes, BuildContext context){
    List<Marker> list = [];
    for (var plante in plantes) {
      if(plante.latitude != null && plante.longitude != null){
        list.add(Marker(
          point: LatLng(plante.latitude!, plante.longitude!),
          width: 100,
          height: 100,
          child: GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPlante(plante: plante),
                ),
              );
            },
            child: planteMarker(imagePath: plante.imagePath ?? 'assets/default.png'),
          )
        ));
      }
    }
    return list;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentLocalisation,
              initialZoom: 10,
              maxZoom: 18,
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
                markers: listMarker(widget.plantes, context),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.move(currentLocalisation, 15),
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
