import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'rounded_image.dart';
//services
import '../../controllers/services/media_service.dart';

class EditableImageField extends StatefulWidget {
  final String imagePath;
  final Function setImageFile;
  final PlatformFile? image;
  const EditableImageField(
      {super.key,
      required this.imagePath,
      required this.setImageFile,
      this.image});

  @override
  State<EditableImageField> createState() => _EditableImageFieldState();
}

class _EditableImageFieldState extends State<EditableImageField> {
  late MediaService _mediaService;
  late double _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _mediaService = GetIt.instance.get<MediaService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      child: widget.image != null
          ? _imageWidget()
          : Column(
              children: [
                _imageWidget(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "La imagen es obligatoria",
                  style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
      onTap: () => {
        _mediaService.pickImageFromLibrary().then((PlatformFile? image) {
          if (image != null) {
            widget.setImageFile(image);
          }
        })
      },
    );
  }

  Widget _imageWidget() {
    if (widget.image != null) {
      return RoundedImageFile(
        file: widget.image!,
        imageSize: _deviceHeight * 0.15,
      );
    }
    return RoundedImageNetwork(
      imagePath: widget.imagePath,
      imageSize: _deviceHeight * 0.15,
    );
  }
}
