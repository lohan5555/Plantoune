import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plantoune/models/plante.dart';
import 'package:plantoune/screens/detailPlante.dart';

class HerbierPage extends StatelessWidget {
  final List<Plante> plantes;
  final Function(int) onDelete;

  const HerbierPage({
    super.key,
    required this.plantes,
    required this.onDelete,
  });

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
          return FleureCard(
            plante: plantes[index],
            onDelete: () => onDelete(plantes[index].id!)
          );
        },
      );
    }
  }
}

//Card d'affichage d'une plante
class FleureCard extends StatelessWidget{
  final Plante plante;
  final VoidCallback onDelete;

  const FleureCard({super.key, required this.plante, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 5,
      child: InkWell(
        onTap:() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPlante(plante: plante),
            ),
          );
        },
        child: SizedBox(
          height: 150,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: plante.imagePath != null
                  ?Image.file(
                    File(plante.imagePath!),
                    fit: BoxFit.cover,
                  )
                  :Image.asset(
                    'assets/default.png',
                    fit: BoxFit.cover,
                  ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plante.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        plante.text ?? 'Aucune description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              //TODO
                              print("test edit");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Attention'),
                                content: const Text('Êtes-vous sur de vouloir supprimer cette plante ? Cette action est définitive.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () => {
                                      Navigator.pop(context, 'OK'),
                                      onDelete()
                                    },
                                    child: const Text('OK')),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ]
                  )
                )
              ),
            ],
          )
        ),
      )
    );
  }

}