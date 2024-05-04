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
            .map((doc) => Category.fromJson({...doc.data(), "id": doc.id}))
            .toList());
  }

  Future<bool> add(String name) async {
    var category = {
      "name": name,
      "creationDate": DateTime.now(),
      "hidden": false,
    };
    try {
      await _db.collection(_categoriesCollection).add(category);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(Category updateCategory) async {
    try {
      await _db
          .collection(_categoriesCollection)
          .doc(updateCategory.id)
          .update(updateCategory.toJson());
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
