import 'package:flutter/material.dart';
import 'package:plantoune/models/plante.dart';

class HerbierPage extends StatelessWidget {
  final List<Plante> plantes;

  const HerbierPage({super.key, required this.plantes});

  @override
  Widget build(BuildContext context) {
    if(plantes.isEmpty){
      return const Center(
        child: Image(image: AssetImage('assets/home.png')),
      );
    }else{
      return ListView.builder(
        itemCount: plantes.length,
        itemBuilder: (context, index){
          final plante = plantes[index];
          return ListTile(
            title: Text(plante.name),
          );
        },
      );
    }
  }
}
