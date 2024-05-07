import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RectangleImageNetwork extends StatelessWidget {
  final String imagePath;
  final double imageSize;

  const RectangleImageNetwork(
      {super.key, required this.imagePath, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageSize * 3,
      width: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Colors.black,
        image:
            DecorationImage(image: NetworkImage(imagePath), fit: BoxFit.fill),
      ),
    );
  }
}

class RectangleImageFile extends StatelessWidget {
  final PlatformFile file;
  final double imageSize;
  const RectangleImageFile(
      {super.key, required this.file, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageSize * 3,
      width: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Colors.black,
        image: DecorationImage(
          image: FileImage(File(file.path!)),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
