import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mapPref.dart';
import '../data/models/plante.dart';
import '../data/models/planteMarker.dart';
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
  double currentZoom = 10;

  @override
  void initState() {
    super.initState();
    _setCurrentCoordonneesAndZoom();
  }

  void _setCurrentCoordonneesAndZoom() async{
    final prefs = await SharedPreferences.getInstance();
    Position? p = await widget.positionService.getCurrentPosition();

    // Zoom
    if (prefs.containsKey(MapPref.zoom)) {
      final val = prefs.getDouble(MapPref.zoom);
      if (val != null) {
        setState(() {
            currentZoom = val;
        });
      }
    }

    // Coordonnées
    if(p != null){
      final userLatLng = LatLng(p.latitude, p.longitude);
      setState(() {
        currentLocalisation = userLatLng;
      });
      _mapController.move(userLatLng, currentZoom);
    }
  }


  void _updateZoom() {
    MapPref.saveZoomValue(currentZoom);
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
              initialZoom: currentZoom,
              maxZoom: 18,
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
                markers: listMarker(widget.plantes, context),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.move(currentLocalisation, currentZoom),
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}