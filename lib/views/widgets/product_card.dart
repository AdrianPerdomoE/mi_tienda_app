import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/cart_provider.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:mi_tienda_app/controllers/utils/amount_details.dart';
import 'package:mi_tienda_app/controllers/utils/custom_formats.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import 'package:mi_tienda_app/models/product.dart';
import 'package:mi_tienda_app/views/widgets/cart_item_count_widget.dart';
import 'package:provider/provider.dart';

class ProductCardWidget extends StatefulWidget {
  final Product product;
  const ProductCardWidget({super.key, required this.product});

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  late AppDataProvider appDataProvider;
  late CartProvider cartProvider;
  late NotificationService notificationService;
  late Map<String, double> dcValues;
  late double price;
  late double discount;
  late double finalPrice;

  notificationSuccess(String message) {
    notificationService.showNotificationBottom(
      context,
      message,
      NotificationType.success,
    );
  }

  notificationError(String message) {
    notificationService.showNotificationBottom(
      context,
      message,
      NotificationType.error,
    );
  }

  _addToCart() async {
    try {
      await cartProvider.addItemToCart(widget.product.id);
      notificationSuccess('Producto añadido al carrito.');
    } catch (e) {
      notificationError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    cartProvider = context.watch<CartProvider>();
    notificationService = GetIt.instance.get<NotificationService>();
    dcValues = discountValues(widget.product.price, widget.product.discount);
    price = dcValues['price']!;
    discount = dcValues['discount']!;
    finalPrice = dcValues['finalPrice']!;

    return InkWell(
      onTap: () => showProductDetails(),
      child: Card(
        color: appDataProvider.backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: appDataProvider.accentColor, // Color del borde
            width: 1, // Grosor del borde
          ),
          borderRadius: BorderRadius.circular(8.0), // Radio de las esquinas
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: appDataProvider.accentColor,
                      width: 1,
                    ),
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: const SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 8, top: 10),
              child: Text(
                widget.product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  color: appDataProvider.textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 12),
              child: Row(
                children: [
                  Text(
                    toCOP(price),
                    style: TextStyle(
                      fontWeight:
                          discount != 0 ? FontWeight.normal : FontWeight.bold,
                      fontSize: 14,
                      color: appDataProvider.accentColor,
                      decoration: discount != 0
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: appDataProvider.accentColor,
                    ),
                  ),
                  if (discount != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        toCOP(finalPrice),
                        style: TextStyle(
                          fontSize: 14,
                          color: appDataProvider.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (discount != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appDataProvider.accentColor,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          toPercentage(discount * -1),
                          style: TextStyle(
                            fontSize: 10,
                            color: appDataProvider.backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 12),
              child: StreamBuilder<CartItem>(
                  stream: cartProvider.getCartItem(widget.product.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      CartItem cartItem = snapshot.data!;
                      return Center(
                        child: CartItemCountWidget(cartItem: cartItem),
                      );
                    } else {
                      return Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appDataProvider.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                          ),
                          onPressed: () => _addToCart(),
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: appDataProvider.backgroundColor,
                            size: 14,
                            weight: 500,
                          ),
                          label: Text(
                            'Añadir',
                            style: TextStyle(
                                color: appDataProvider.backgroundColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void showProductDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appDataProvider.backgroundColor,
          alignment: Alignment.center,
          contentPadding: const EdgeInsets.all(24),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          title: Text(widget.product.name),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          titleTextStyle: TextStyle(
            color: appDataProvider.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          contentTextStyle: const TextStyle(
            fontSize: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: appDataProvider.backgroundColor,
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: appDataProvider.accentColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${widget.product.stock} unidades disponibles",
                  style: TextStyle(
                    fontSize: 14,
                    color: appDataProvider.accentColor,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      toCOP(price),
                      style: TextStyle(
                        fontWeight:
                            discount != 0 ? FontWeight.normal : FontWeight.bold,
                        fontSize: 20,
                        color: appDataProvider.textColor,
                        decoration: discount != 0
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: appDataProvider.textColor,
                      ),
                    ),
                    if (discount != 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          toCOP(finalPrice),
                          style: TextStyle(
                            fontSize: 20,
                            color: appDataProvider.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (discount != 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appDataProvider.accentColor,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            toPercentage(discount * -1),
                            style: TextStyle(
                              fontSize: 16,
                              color: appDataProvider.backgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: appDataProvider.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
              ),
              onPressed: () {
                _addToCart();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.add_shopping_cart,
                color: appDataProvider.backgroundColor,
                size: 16,
              ),
              label: Text(
                'Añadir',
                style: TextStyle(
                  color: appDataProvider.backgroundColor,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
