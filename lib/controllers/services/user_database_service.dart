//package
import 'package:cloud_firestore/cloud_firestore.dart';
//models
import '../../models/store_user.dart';
import '../../models/cart.dart';

const String _usersCollections = "Users";

class UserDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserDatabaseService();
  Future<IUser?> getUser(String uid) async {
    return _db.collection(_usersCollections).doc(uid).get().then((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      switch (userData['role']) {
        case customer:
          return Customer.fromJson({"id": uid, ...userData});
        case admin:
          return Admin.fromJson({"id": uid, ...userData});
        default:
          throw Exception("User role not found");
      }
    });
  }

  Stream<IUser> getStreamUser(String uid) {
    return _db
        .collection(_usersCollections)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw Exception("User not found");
      }
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      switch (userData['role']) {
        case customer:
          return Customer.fromJson({"id": uid, ...userData});
        case admin:
          return Admin.fromJson({"id": uid, ...userData});
        default:
          throw Exception("User role not found");
      }
    });
  }

  Future<void> updateUserData(IUser userChanged) async {
    try {
      await _db
          .collection(_usersCollections)
          .doc(userChanged.id)
          .update(userChanged.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> createCustomer(String uid, String name, String email,
      String imageUrl, String address) async {
    try {
      await _db.collection(_usersCollections).doc(uid).set({
        "name": name,
        "email": email,
        "image": imageUrl,
        "creationDate": Timestamp.now(),
        "role": customer,
        "cart": Cart(items: []).toJson(),
        "maxCredit": 10000.0,
        "address": address
      });
    } catch (e) {
      print(e);
    }
  }
}
