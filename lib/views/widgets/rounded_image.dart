import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RoundedImageNetwork extends StatelessWidget {
  final String imagePath;
  final double imageSize;

  const RoundedImageNetwork(
      {super.key, required this.imagePath, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class RoundedImageFile extends StatelessWidget {
  final PlatformFile file;
  final double imageSize;
  const RoundedImageFile(
      {super.key, required this.file, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        image: DecorationImage(
          image: FileImage(File(file.path!)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
