import 'dart:io';
//packages
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CloudStorageService();
}
