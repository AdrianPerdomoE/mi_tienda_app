import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/cloud_storage_service.dart';
import 'package:mi_tienda_app/models/comment.dart';
import 'package:mi_tienda_app/models/distributor.dart';

class DistributorDatabaseService {
  final String _distributorsCollections = "Distributors";
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CloudStorageService _cloudStorageService;
  late Stream<List<Distributor>> _distributors;
  get distributors => _distributors;
  DistributorDatabaseService() {
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _distributors =
        _db.collection(_distributorsCollections).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Distributor.fromJson({"id": doc.id, ...doc.data()}))
          .toList();
    });
  }

  Future<bool> updateDistributor(Distributor distributorChanged) async {
    try {
      await _db
          .collection(_distributorsCollections)
          .doc(distributorChanged.id)
          .update(distributorChanged.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addDistributor(
      String name,
      String number,
      String email,
      String address,
      String description,
      PlatformFile image,
      int rating) async {
    var distributor = {
      "name": name,
      "imageUrl": "https://picsum.photos/200", // Placeholder image URL
      "number": number,
      "email": email,
      "address": address,
      "comments": [],
      "description": description,
      "rating": rating,
    };
    try {
      DocumentReference distributorRef =
          await _db.collection(_distributorsCollections).add(distributor);
      String distributorId = distributorRef.id;
      // Upload image to storage
      String? imageUrl = await _cloudStorageService
          .saveDistributorImageToStorage(distributorId, image);
      if (imageUrl != null) {
        await distributorRef.update({"imageUrl": imageUrl});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDistributor(String distributorId) async {
    try {
      await _db
          .collection(_distributorsCollections)
          .doc(distributorId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addCommentToDistributor(
      String distributorId, Comment comment) async {
    try {
      await _db.collection(_distributorsCollections).doc(distributorId).update({
        "comments": FieldValue.arrayUnion([comment.toJson()])
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
