import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantoune/models/plante.dart';

class DetailPlante extends StatelessWidget {
  const DetailPlante({super.key, required this.plante});

  final Plante plante;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(plante.name),
        backgroundColor: const Color(0xffd5f2c9),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    plante.imagePath == null
                        ? Image.asset('assets/default.png', fit: BoxFit.cover)
                        : Image.file(File(plante.imagePath!), fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [Row(
                          children: [
                            const Icon(Icons.location_on, size: 20, color: Colors.green,),
                            const SizedBox(width: 6),
                            Text(
                              plante.latitude != null && plante.longitude != null
                                  ? '${plante.latitude}, ${plante.longitude}'
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
                              (plante.text == null)
                                  ? 'Aucune description'
                                  : plante.text!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: (plante.text == null)
                                    ? Colors.grey
                                    : Colors.black,
                                fontStyle: (plante.text == null)
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
