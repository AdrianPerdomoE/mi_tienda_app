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
    getAllProducts();
  }

  void getAllProducts() {
    _products = _db
        .collection(_productsCollection)
        .where("hidden", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromJson({"id": doc.id, ...doc.data()}))
            .toList());
  }

  void filterProductsByName(String name) {
    if (name.isEmpty) {
      getAllProducts();
    } else {
      _products = _db
          .collection(_productsCollection)
          .where("hidden", isEqualTo: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Product.fromJson({"id": doc.id, ...doc.data()}))
            .where((product) =>
                product.name.toLowerCase().contains(name.toLowerCase()))
            .toList();
      });
    }
  }

  void filterProductsByCategories(List<String> categoryIds) {
    if (categoryIds.isEmpty) {
      getAllProducts();
    } else {
      _products = _db
          .collection(_productsCollection)
          .where("hidden", isEqualTo: false)
          .where("categoryId", whereIn: categoryIds)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromJson({"id": doc.id, ...doc.data()}))
              .toList());
    }
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

  Future<bool> update(Product updatedProduct, PlatformFile? newImage) async {
    if (newImage != null) {
      String? imageUrl = await _cloudStorageService
          .saveDistributorImageToStorage(updatedProduct.id, newImage);
      if (imageUrl != null) {
        updatedProduct.imageUrl = imageUrl;
      }
    }
    try {
      await _db
          .collection(_productsCollection)
          .doc(updatedProduct.id)
          .update(updatedProduct.toJson());
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
