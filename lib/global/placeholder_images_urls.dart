class PlaceholderImagesUrls {
  // clase para centralizar imagenes de relleno
  static List<String> get placeholderImages => [
        PlaceholderImagesUrls.png150Image,
      ]; // lista de imagenes de relleno, se puede agregar más, solo se debe agregar la url de la imagen, se usa para verificar si la imagen que se quiere cargar es una imagen de relleno
  static const String png150Image =
      'https://firebasestorage.googleapis.com/v0/b/mi-tienda-app-801c9.appspot.com/o/images%2Fplaceholders%2F150.png?alt=media'; // imagen de relleno de 150x150
}
