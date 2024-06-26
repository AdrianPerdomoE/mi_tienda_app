import 'dart:io';
//packages
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CloudStorageService();

  Future<String?> saveUserImageToStorage(String uid, PlatformFile image) async {
    try {
      Reference reference =
          _storage.ref().child('images/users/$uid/profile.${image.extension}');
      UploadTask task = reference.putFile(File(image.path!));
      return await task.then((result) {
        return result.ref.getDownloadURL();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> saveProductImageToStorage(
      String productId, String productName, PlatformFile image) async {
    try {
      Reference reference = _storage.ref().child(
          'images/products/$productId/${productName}_${Timestamp.now().millisecondsSinceEpoch}.${image.extension}');
      UploadTask task = reference.putFile(File(image.path!));
      return await task.then((result) {
        return result.ref.getDownloadURL();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> saveDistributorImageToStorage(
      String distributorID, PlatformFile image) async {
    try {
      Reference reference = _storage.ref().child(
          'images/distributors/$distributorID/profile.${image.extension}');
      UploadTask task = reference.putFile(File(image.path!));
      return await task.then((result) {
        return result.ref.getDownloadURL();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
