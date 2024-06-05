import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';

import 'rectangle_image.dart';
import 'rounded_image.dart';
//services
import '../../controllers/services/media_service.dart';

class EditableImageField extends StatefulWidget {
  // Clase que define un campo de imagen editable
  final String imagePath; // Ruta de la imagen para network
  final Function
      setImageFile; // Funcion para setear la imagen seleccionada en galeria
  final PlatformFile?
      image; // Referencia a la imagen seleccionada de la plataforma

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
      // Widget que permite detectar gestos
      child: widget.image !=
                  null || // Si la imagen es diferente de null o la ruta de la imagen no esta en la lista de imagenes de prueba, se muestra la imagen
              !PlaceholderImagesUrls.placeholderImages
                  .contains(widget.imagePath)
          ? _imageWidget()
          : Column(
              // Si no, se muestra un mensaje de que la imagen es obligatoria
              children: [
                _imageWidget(), // Widget que muestra la imagen placeholder
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
    // Widget que muestra la imagen
    if (widget.image != null) {
      return RoundedImageFile(
        // Widget que muestra la imagen seleccionada
        file: widget.image!,
        imageSize: _deviceHeight * 0.15,
      );
    }
    return RoundedImageNetwork(
      // Widget que muestra la imagen de la red
      imagePath: widget.imagePath,
      imageSize: _deviceHeight * 0.15,
    );
  }
}

class EditableImageRectangleField extends StatefulWidget {
  // Clase que define un campo de imagen editable
  final String imagePath; // Ruta de la imagen para network
  final Function
      setImageFile; // Funcion para setear la imagen seleccionada en galeria
  final PlatformFile?
      image; // Referencia a la imagen seleccionada de la plataforma
  final double size;
  const EditableImageRectangleField(
      {super.key,
      required this.imagePath,
      required this.setImageFile,
      this.image,
      required this.size});

  @override
  State<EditableImageRectangleField> createState() =>
      _EditableImageRectangleFieldState();
}

class _EditableImageRectangleFieldState
    extends State<EditableImageRectangleField> {
  late MediaService _mediaService;

  @override
  Widget build(BuildContext context) {
    _mediaService = GetIt.instance.get<MediaService>();

    return GestureDetector(
      // Widget que permite detectar gestos
      child: widget.image !=
                  null || // Si la imagen es diferente de null o la ruta de la imagen no esta en la lista de imagenes de prueba, se muestra la imagen
              !PlaceholderImagesUrls.placeholderImages
                  .contains(widget.imagePath)
          ? _imageWidget()
          : Column(
              // Si no, se muestra un mensaje de que la imagen es obligatoria
              children: [
                _imageWidget(), // Widget que muestra la imagen placeholder
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
    // Widget que muestra la imagen
    if (widget.image != null) {
      return RectangleImageFile(
          // Widget que muestra la imagen seleccionada
          file: widget.image!,
          imageSize: widget.size);
    }
    return RectangleImageNetwork(
      // Widget que muestra la imagen de la red
      imagePath: widget.imagePath,
      imageSize: widget.size,
    );
  }
}
