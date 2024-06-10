import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/cart_provider.dart';
import 'package:mi_tienda_app/controllers/providers/customer_orders_provider.dart';
import 'package:mi_tienda_app/controllers/utils/custom_formats.dart';
import 'package:mi_tienda_app/models/payment_method.dart';
import 'package:mi_tienda_app/views/screens/customer/customer_checkout_shipment_screen.dart';
import 'package:provider/provider.dart';

class CustomerCheckoutPaymentScreen extends StatefulWidget {
  const CustomerCheckoutPaymentScreen({super.key});

  @override
  State<CustomerCheckoutPaymentScreen> createState() =>
      _CustomerCheckoutPaymentScreenState();
}

class _CustomerCheckoutPaymentScreenState
    extends State<CustomerCheckoutPaymentScreen> {
  late CartProvider cartProvider;
  late CustomerOrdersProvider ordersProvider;

  @override
  void initState() {
    super.initState();
    final cartProvider = context.read<CartProvider>();
    cartProvider.getCart();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = context.watch<CartProvider>();
    ordersProvider = context.watch<CustomerOrdersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de pago'),
      ),
      body: StreamBuilder<double>(
        stream: cartProvider.totalPrice,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          double totalPrice = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Total a pagar:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                toCOP(totalPrice),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Seleccionar método de pago',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              RadioListTile(
                title: const Text('Pago en línea'),
                value: PaymentMethod.enLinea,
                groupValue: ordersProvider.selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    ordersProvider.setPaymentMethod(value as PaymentMethod?);
                  });
                },
              ),
              RadioListTile(
                title: const Text('Pago contraentrega'),
                value: PaymentMethod.contraEntrega,
                groupValue: ordersProvider.selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    ordersProvider.setPaymentMethod(value as PaymentMethod?);
                  });
                },
              ),
              RadioListTile(
                title: const Text('Fiado'),
                value: PaymentMethod.fiado,
                groupValue: ordersProvider.selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    ordersProvider.setPaymentMethod(value as PaymentMethod?);
                  });
                },
              ),
              ElevatedButton(
                onPressed: ordersProvider.selectedPaymentMethod != null
                    ? () {
                        if (ordersProvider.selectedPaymentMethod ==
                            PaymentMethod.enLinea) {
                              confirmOnlinePayment(totalPrice);
                        } else {
                          goToShipmentScreen();
                        }
                      }
                    : null,
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      ),
    );
  }

  void confirmOnlinePayment(double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar pago en línea'),
          content: Text(
              '¿Está seguro de que desea realizar el pago en línea por ${toCOP(totalPrice)}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                goToShipmentScreen();
              },
              child: const Text('Confirmar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void goToShipmentScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CustomerCheckoutShipmentScreen(),
      ),
    );
  }
}
