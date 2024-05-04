import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/global/placeholder_images_urls.dart';
import 'package:mi_tienda_app/models/product.dart';

import 'cloud_storage_service.dart';

class ProductsDatabaseService {
  final String _productsCollection = "Products";
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<List<Product>> _products;
  get products => _products;
  final CloudStorageService _cloudStorageService =
      GetIt.instance.get<CloudStorageService>();
  ProductsDatabaseService() {
    _products = _db.collection(_productsCollection).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Product.fromJson(doc.data()..["id"] = doc.id))
            .toList());
  }

  Future<bool> add(String name, String description, PlatformFile image,
      double price, String categoryId, int stock, double discount) async {
    var product = {
      "name": name,
      "description": description,
      "imageUrl": PlaceholderImagesUrls.png150Image,
      "price": price,
      "categoryId": categoryId,
      "creationDate": DateTime.now(),
      "hidden": false,
      "stock": stock,
      "discount": discount
    };
    try {
      DocumentReference productRef =
          await _db.collection(_productsCollection).add(product);
      String productId = productRef.id;
      //Upload image to storage
      String? imageUrl = await _cloudStorageService
          .saveDistributorImageToStorage(productId, image);
      if (imageUrl != null) {
        await productRef.update({"imageUrl": imageUrl});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(
      String id,
      String name,
      String description,
      String imageUrl,
      double price,
      String categoryId,
      DateTime creationDate,
      bool hidden,
      int stock,
      double discount) async {
    Product product = Product(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        price: price,
        categoryId: categoryId,
        creationDate: creationDate,
        hidden: hidden,
        stock: stock,
        discount: discount);
    try {
      await _db
          .collection(_productsCollection)
          .doc(id)
          .update(product.toJson().remove("id"));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateHidden(String id, bool hidden) async {
    var product = {
      "hidden": hidden,
    };
    try {
      await _db.collection(_productsCollection).doc(id).update(product);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _db.collection(_productsCollection).doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
