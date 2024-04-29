import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/product.dart';

class ProductsDatabaseService {
  final String _productsCollection = "products";
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<List<Product>> _products;
  get products => _products;

  ProductsDatabaseService() {
    _products = Stream.value([
      Product(
        id: "1",
        name: "Leche Entera Tetra Pak Latti 200ml",
        description: "200 ml (ml a \$ 5.95)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12003216.png",
        price: 1190,
        categoryId: "category_1",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 100,
        discount: 0,
      ),
      Product(
        id: "2",
        name: "Gaseosa Pony Malta Mini 200ml",
        description: "200 ml (ml a \$ 7,75)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12000105.png",
        price: 1550,
        categoryId: "category_2",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 210,
        discount: 0,
      ),
      Product(
        id: "3",
        name: "Leche Malteada Milo 4und - 720ml",
        description: "720 ml (ml a \$ 14,43)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12002215.png",
        price: 10390,
        categoryId: "category_3",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 36,
        discount: 0,
      ),
      Product(
        id: "4",
        name: "Atún Aceite de Oliva Carlo Forte 160g",
        description: "104 g (g a \$ 72,02)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12000590.png",
        price: 7490,
        categoryId: "category_2",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 70,
        discount: 0,
      ),
      Product(
        id: "5",
        name: "Salsa de Tomate Fruco 650g",
        description: "650 g (g a \$ 17,68)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12003759.png",
        price: 11490,
        categoryId: "category_1",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 63,
        discount: 0,
      ),
      Product(
        id: "6",
        name: "Prosecco Italiano Torresella 750ml",
        description: "750 ml (ml a \$ 53,32)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12003316.png",
        price: 39990,
        categoryId: "category_3",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 62,
        discount: 0,
      ),
      Product(
        id: "7",
        name: "Pañales Talla XG Little Angels 30und",
        description: "30 un (un a \$ 833)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12002043.png",
        price: 24990,
        categoryId: "category_2",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 16,
        discount: 0.3,
      ),
      Product(
        id: "8",
        name: "Mix de Verduras Cooltivo 500g",
        description: "500 g (g a \$ 11,38)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12002532.png",
        price: 5690,
        categoryId: "category_1",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 90,
        discount: 0,
      ),
      Product(
        id: "9",
        name: "Arroz Integral Diana 1000g",
        description: "1000 g (g a \$ 4,5)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12003653.png",
        price: 4500,
        categoryId: "category_3",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 124,
        discount: 0.65,
      ),
      Product(
        id: "10",
        name: "Arepa de Maíz con Avena y Chia Masmaí",
        description: "5 un (un a \$ 878)",
        imageUrl: "https://stockimages.tiendasd1.com/stockimages.tiendasd1.com/kobastockimages/IMAGENES/12002550.png",
        price: 4390,
        categoryId: "category_2",
        creationDate: DateTime.now(),
        hidden: false,
        stock: 13,
        discount: 0,
      ),
    ]);
  }

  Future<bool> add(
      String name,
      String description,
      String imageUrl,
      double price,
      String categoryId,
      DateTime creationDate,
      bool hidden,
      int stock,
      double discount) async {
    var product = {
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "price": price,
      "categoryId": categoryId,
      "creationDate": creationDate,
      "hidden": hidden,
      "stock": stock,
      "discount": discount
    };
    try {
      await _db.collection(_productsCollection).add(product);
      // String productId = productRef.id;
      // Upload image to storage
      // String? imageUrl = await _cloudStorageService
      //     .saveDistributorImageToStorage(productId, image);
      // if (imageUrl != null) {
      //   await productRef.update({"imageUrl": imageUrl});
      // }
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
    try {
      await _db
          .collection(_productsCollection)
          .doc(id)
          .update({"hidden": hidden});
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
