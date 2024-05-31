import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/cart_provider.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import 'package:provider/provider.dart';

class CartItemCountWidget extends StatefulWidget {
  final CartItem cartItem;
  const CartItemCountWidget({
    super.key,
    required this.cartItem,
  });

  @override
  _CartItemCountWidgetState createState() => _CartItemCountWidgetState();
}

class _CartItemCountWidgetState extends State<CartItemCountWidget> {
  late AppDataProvider appDataProvider;
  late CartProvider cartProvider;
  late NotificationService notificationService;
  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    cartProvider = context.watch<CartProvider>();
    notificationService = NotificationService();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                isLoading
                    ? appDataProvider.primaryColor.withOpacity(0.5)
                    : appDataProvider.primaryColor,
              ),
              iconColor: MaterialStateProperty.all<Color>(
                isLoading
                    ? appDataProvider.backgroundColor.withOpacity(0.5)
                    : appDataProvider.backgroundColor,
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(0),
              ),
            ),
            icon: widget.cartItem.quantity == 1
                ? const Icon(Icons.delete, size: 20)
                : const Icon(Icons.remove, size: 20),
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      if (widget.cartItem.quantity == 1) {
                        await cartProvider
                            .removeItemFromCart(widget.cartItem.productId);
                        notificationSuccess('Producto eliminado del carrito');
                      } else {
                        await cartProvider
                            .decreaseOneItemFromCart(widget.cartItem.productId);
                      }
                    } catch (e) {
                      notificationError(e.toString());
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            widget.cartItem.quantity.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                isLoading
                    ? appDataProvider.primaryColor.withOpacity(0.5)
                    : appDataProvider.primaryColor,
              ),
              iconColor: MaterialStateProperty.all<Color>(
                isLoading
                    ? appDataProvider.backgroundColor.withOpacity(0.5)
                    : appDataProvider.backgroundColor,
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(0),
              ),
            ),
            icon: const Icon(Icons.add, size: 20),
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await cartProvider
                          .increaseOneItemToCart(widget.cartItem.productId);
                    } catch (e) {
                      notificationError(e.toString());
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
          ),
        ),
      ],
    );
  }
}
