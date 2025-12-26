import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:plantoune/models/plante.dart';
import 'package:geolocator/geolocator.dart';


class FormulaireEdit extends StatefulWidget {
  //final Function(Plante) onEdit;
  final Plante plante;

  const FormulaireEdit({super.key, required this.plante});

  @override
  State<FormulaireEdit> createState() => _FormulaireEditState();
}

class _FormulaireEditState extends State<FormulaireEdit> {
  File? galleryFile;
  final picker = ImagePicker();


  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final textController = TextEditingController();

  var loadingCoordonnees = false;

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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

                                  final position = await _getCurrentPosition();

                                  final planteEditee = widget.plante.copyWith(
                                    name: nameController.text,
                                    text: textController.text.trim().isEmpty
                                        ? null
                                        : textController.text.trim(),
                                    imagePath: galleryFile?.path,
                                    latitude: position?.latitude,
                                    longitude: position?.longitude,
                                  );

                                  //on retourne sur le composant fleurCard, qui attent un objet de type fleur
                                  //donc on renvoie notre planteEditee
                                  Navigator.pop(context, planteEditee);

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
                                    : const Text('Modifier'),
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

  //permet de sauvegarder une image dans l'appareil
  Future<File> _saveImagePermanently(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName = p.basename(image.path);
    final savedImage = File('${directory.path}/$fileName');

    return File(image.path).copy(savedImage.path);
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
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //sauvegarde une copie de l'image, car le path de l'image orginal est temporaire
  Future<void> getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);

    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing selected')),
      );
      return;
    }

    final savedImage = await _saveImagePermanently(pickedFile);

    setState(() {
      galleryFile = savedImage;
    });
  }


  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le GPS est désactivé')),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission GPS refusée')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission GPS refusée définitivement'),
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }


}