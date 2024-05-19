import 'package:cloud_firestore/cloud_firestore.dart';

class CartDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _usersCollections = "Users";
  final String _uid;

  CartDatabaseService(this._uid);


}