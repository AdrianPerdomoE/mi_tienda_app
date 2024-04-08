//package
import 'package:cloud_firestore/cloud_firestore.dart';

const String _APP_DATA_COLLECTION = "AppData";

const String _CATEGORIES_COLLECTION = "Categories";

const String _ORDERS_COLLECTION = "Orders";

const String _PRODUCTS_COLLECTION = "Products";

const String _SHIPMENTS_COLLECTION = "Shipments";

const String _DISTRIBUTORS_COLLECTION = "Distributors";

const String _USER_COLLECTION = "Users";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService();
  Future<DocumentSnapshot> getUser(String uid) async {
    return _db.collection(_USER_COLLECTION).doc(uid).get();
  }

  /* Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await _db.collection(_USER_COLLECTION).doc(uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  } */
}
