import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantoune/models/plante.dart';
import 'package:plantoune/services/imageService.dart';
import 'package:plantoune/services/positionService.dart';


class FormulaireAjout extends StatefulWidget {
  final Function(Plante) onCreate;

  const FormulaireAjout({super.key, required this.onCreate});

  @override
  State<FormulaireAjout> createState() => _FormulaireAjoutState();
}

class _FormulaireAjoutState extends State<FormulaireAjout> {
  //pour récupérer et stocker l'image
  File? galleryFile;
  final ImageService imageService = ImageService();

  //pour le formulaire
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final textController = TextEditingController();

  //pour le feedback CircularProgressIndicator
  var loadingCoordonnees = false;

  final PositionService positionService = PositionService();

  // permet de libérer la mémoire allouée aux variables lorsque le state est
  // supprimé, pour éviter des fuites de mémoires
  @override
  void dispose() {
    nameController.dispose();
    textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //redimentionne le body pour éviter que des widgets soit caché par le clavier virtuel
      appBar: AppBar(
        title: const Text('Ajouter une nouvelle plante !'),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ElevatedButton(
                                onPressed: loadingCoordonnees
                                  ? null
                                  : () async {
                                  if (!_formKey.currentState!.validate()) return;

                                  setState(() {
                                    loadingCoordonnees = true;
                                  });

                                  final position = await positionService.getCurrentPosition();
                                  if (position == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Impossible de récupérer la position')),
                                    );
                                  }

                                  final plante = Plante(
                                    name: nameController.text,
                                    text: textController.text.trim().isEmpty
                                        ? null
                                        : textController.text.trim(), //pour mettre 'NULL' au lieu d'une chaine vide
                                    imagePath: galleryFile?.path,
                                    latitude: position?.latitude,
                                    longitude: position?.longitude,
                                  );

                                  widget.onCreate(plante);
                                  Navigator.pop(context);

                                  setState(() {
                                    loadingCoordonnees = false;
                                  });
                                },
                                child: loadingCoordonnees
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Text('Créer'),
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