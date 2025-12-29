import 'dart:io';

import 'package:flutter/material.dart';

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