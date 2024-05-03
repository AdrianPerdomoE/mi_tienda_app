import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/category.dart';

class CategoriesDatabaseService {
  final String _categoriesCollection = "Categories";
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<List<Category>> _categories;
  get categories => _categories;

  CategoriesDatabaseService() {
    _categories = _db.collection(_categoriesCollection).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Category.fromJson({"id": doc.id, ...doc.data()}))
            .toList());
  }

  Future<bool> add(String name, DateTime creationDate, bool hidden) async {
    var category = {
      "name": name,
      "creationDate": creationDate,
      "hidden": hidden,
    };
    try {
      await _db.collection(_categoriesCollection).add(category);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(
      String id, String name, Timestamp creationDate, bool hidden) async {
    var category = {
      "name": name,
      "creationDate": creationDate,
      "hidden": hidden,
    };
    try {
      await _db.collection(_categoriesCollection).doc(id).update(category);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateHidden(String id, bool hidden) async {
    var category = {
      "hidden": hidden,
    };
    try {
      await _db.collection(_categoriesCollection).doc(id).update(category);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _db.collection(_categoriesCollection).doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
