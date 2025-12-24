import 'package:flutter/material.dart';
import 'package:plantoune/models/plante.dart';

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
      elevation: 5,
      child: InkWell(
        onTap:() {
          //TODO
          print("redirection vers DetailPlante");
        },
        child: SizedBox(
          height: 150,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: plante.imagePath != null
                    ?Image.asset(
                  'assets/default.png',
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
                            onPressed: () {
                              onDelete();
                            },
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