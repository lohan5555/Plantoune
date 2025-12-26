import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/plante.dart';

class CartePage extends StatelessWidget {
  const CartePage({super.key, required this.plantes});

  final List<Plante> plantes;

  //créer une liste de marker à partir de la liste des plantes
  List<Marker> listMarker(List<Plante> plantes){
    List<Marker> list = [];
    for (var plante in plantes) {
      if(plante.latitude != null && plante.longitude != null){
        list.add(Marker(
          point: LatLng(plante.latitude!, plante.longitude!),
          width: 100,
          height: 100,
          child: GestureDetector(
            onTap: (){
              //TODO
              print("redirection vers DetailPlante");
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
            options: const MapOptions(
              initialCenter: LatLng(45.566669, 5.93333),
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
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
              MarkerLayer(
                markers: listMarker(plantes),
              ),
            ],
          )
        ],
      ),
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
