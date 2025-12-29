import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:plantoune/models/plante.dart';
import 'package:plantoune/screens/carteEdit.dart';
import 'package:plantoune/services/imageService.dart';


class FormulaireEdit extends StatefulWidget {
  final Plante plante;

  const FormulaireEdit({super.key, required this.plante});

  @override
  State<FormulaireEdit> createState() => _FormulaireEditState();
}

class _FormulaireEditState extends State<FormulaireEdit> {
  File? galleryFile;
  final ImageService imageService = ImageService();


  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final textController = TextEditingController();
  final longitudeController = TextEditingController();
  final latitudeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    nameController.text = widget.plante.name;
    textController.text = widget.plante.text ?? '';

    if (widget.plante.imagePath != null) {
      galleryFile = File(widget.plante.imagePath!);
    }

    latitudeController.text = widget.plante.latitude.toString();
    longitudeController.text = widget.plante.longitude.toString();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Modifier une plante'),
        backgroundColor: Color(0xffd5f2c9),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child:SingleChildScrollView(
          child: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nom :"),
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un nom';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text("Description :"),
                            TextFormField(
                              controller: textController,
                              validator: (value) {return null;},
                            ),
                            SizedBox(height: 20),

                            Text("Latitude : "),
                            TextFormField(
                              controller: latitudeController,
                              validator: (value){
                                if(value == null || value.isEmpty){return 'Veuillez entrer une valeur';}
                                if(double.tryParse(value) == null){
                                  return 'Veillez entrer des coordonnées valide';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),


                            Text("Longitude : "),
                            TextFormField(
                              controller: longitudeController,
                              validator: (value){
                                if(value == null || value.isEmpty){return 'Veuillez entrer une valeur';}
                                if(double.tryParse(value) == null){
                                  return 'Veillez entrer des coordonnées valide';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () async{
                                final LatLng? position = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CarteEditPage(
                                      initialPosition: LatLng(
                                        double.parse(latitudeController.text),
                                        double.parse(longitudeController.text),
                                      ),
                                      plante: widget.plante,
                                    ),
                                  ),
                                );
                                if (position != null) {
                                  setState(() {
                                    latitudeController.text = position.latitude.toString();
                                    longitudeController.text = position.longitude.toString();
                                  });
                                }
                              },
                              child: const Icon(Icons.my_location)
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) return;

                                  final planteEditee = widget.plante.copyWith(
                                    name: nameController.text,
                                    text: textController.text.trim().isEmpty
                                        ? null
                                        : textController.text.trim(),
                                    imagePath: galleryFile?.path,
                                    latitude: double.parse(latitudeController.text),
                                    longitude: double.parse(longitudeController.text),
                                  );

                                  //on retourne sur le composant fleurCard, qui attend un objet de type fleur
                                  //donc on renvoie notre planteEditee
                                  Navigator.pop(context, planteEditee);
                                },
                                child: const Text('Modifier'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffd5f2c9),
                            foregroundColor: Colors.black),
                        child: const Text('Ajouter une image'),
                        onPressed: () {
                          _showPicker(context: context);
                        },
                      ),
                      SizedBox(
                        height: 200.0,
                        width: 300.0,
                        child: galleryFile == null
                            ? const Center(child: Text("Vous n'avez pas encore selectionné d'image."))
                            : Center(child: Image.file(galleryFile!)),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      )
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await imageService.pickAndSaveImage(ImageSource.gallery);
                  if (image != null) {
                    setState(() => galleryFile = image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await imageService.pickAndSaveImage(ImageSource.camera);
                  if (image != null) {
                    setState(() => galleryFile = image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

}