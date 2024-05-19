import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/utils/amount_details.dart';
import 'package:mi_tienda_app/controllers/utils/custom_formats.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late AppDataProvider appDataProvider;
  late Map<String, double> dcValues;
  late double price;
  late double discount;
  late double finalPrice;
  late double subTotal;

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    dcValues = discountValues(widget.cartItem.price, widget.cartItem.discount);
    price = dcValues['price']!;
    discount = dcValues['discount']!;
    finalPrice = dcValues['finalPrice']!;
    subTotal = finalPrice * widget.cartItem.quantity;

    return ListTile(
      leading: Stack(
        children: [
          Image.network(widget.cartItem.imageUrl),
          if (discount != 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: appDataProvider.accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  toPercentage(discount * -1),
                  style: TextStyle(
                    fontSize: 12,
                    color: appDataProvider.backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        widget.cartItem.productName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: appDataProvider.textColor,
          height: 1,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Precio: ',
                style: TextStyle(
                  color: appDataProvider.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                toCOP(price),
                style: TextStyle(
                  fontWeight:
                      discount != 0 ? FontWeight.normal : FontWeight.w500,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Text(
                'Subtotal: ',
                style: TextStyle(
                  color: appDataProvider.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                toCOP(subTotal),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: appDataProvider.accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              // Implement the remove item logic here
            },
          ),
          Text(widget.cartItem.quantity.toString()),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Implement the add item logic here
            },
          ),
        ],
      ),
    );
  }
}
