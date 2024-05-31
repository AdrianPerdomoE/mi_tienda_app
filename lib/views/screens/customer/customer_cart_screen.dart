import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/controllers/providers/cart_provider.dart';
import 'package:mi_tienda_app/controllers/utils/custom_formats.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import 'package:mi_tienda_app/views/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  late AppDataProvider appDataProvider;
  late CartProvider cartProvider;

  @override
  void initState() {
    super.initState();
    final cartProvider = context.read<CartProvider>();
    cartProvider.getCart();
  }

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    cartProvider = context.watch<CartProvider>();

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Carrito de compras',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    cartProvider.clearCart();
                  },
                  child: const Text("Vaciar carrito"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<Cart>(
              stream: cartProvider.cart,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
                  final Cart cart = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final CartItem item = cart.items[index];
                      return CartItemWidget(cartItem: item);
                    },
                  );
                } else if (snapshot.hasData && snapshot.data!.items.isEmpty) {
                  return const Center(
                    child: Text("No hay productos en el carrito"),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: StreamBuilder<double>(
          stream: cartProvider.totalPrice,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            double totalPrice = snapshot.data!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${toCOP(totalPrice)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      appDataProvider.primaryColor,
                    ),
                  ),
                  onPressed: () {
                    // Implement the checkout logic here
                  },
                  child: Text(
                    'Confirmar compra',
                    style: TextStyle(
                      color: appDataProvider.backgroundColor,
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
