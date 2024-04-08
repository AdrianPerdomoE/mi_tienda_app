import 'package:file_picker/file_picker.dart';

class MediaService {
  MediaService();
  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );
    if (result != null) {
      return result.files.first;
    }
    return null;
  }
}
