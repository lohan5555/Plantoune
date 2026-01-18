import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantoune/data/models/plante.dart';

import 'formulaireEdit.dart';

class DetailPlante extends StatefulWidget {

  final void Function(Plante) onEdit;
  final Plante plante;

  const DetailPlante({super.key, required this.plante, required this.onEdit});

  @override
  State<DetailPlante> createState() => _DetailPlanteState();
}

class _DetailPlanteState extends State<DetailPlante>{

  late Plante _plante;

  @override
  void initState() {
    super.initState();
    _plante = widget.plante;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_plante.name),
        backgroundColor: const Color(0xffd5f2c9),
        foregroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () async {
                final planteModifiee = await Navigator.push<Plante>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FormulaireEdit(plante: _plante),
                  ),
                );

                if (planteModifiee != null) {
                  widget.onEdit(planteModifiee);
                  setState(() {
                    _plante = planteModifiee;
                  });
                }
              },
            icon: Icon(Icons.edit)
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _plante.imagePath == null
                        ? Image.asset('assets/default.png', fit: BoxFit.cover)
                        : Image.file(File(_plante.imagePath!), fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [Row(
                          children: [
                            const Icon(Icons.location_on, size: 20, color: Colors.green,),
                            const SizedBox(width: 6),
                            Text(
                              _plante.latitude != null && _plante.longitude != null
                                  ? '${_plante.latitude}, ${_plante.longitude}'
                                  : 'Localisation inconnue',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),

                          const SizedBox(height: 16),

                          Text(
                            'Description',
                            style: theme.textTheme.titleMedium,
                          ),

                          const SizedBox(height: 8),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (_plante.text == null)
                                  ? 'Aucune description'
                                  : _plante.text!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: (_plante.text == null)
                                    ? Colors.grey
                                    : Colors.black,
                                fontStyle: (_plante.text == null)
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
