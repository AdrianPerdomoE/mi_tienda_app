import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/authentication_provider.dart';
import 'package:mi_tienda_app/controllers/providers/cart_provider.dart';
import 'package:mi_tienda_app/controllers/providers/customer_orders_provider.dart';
import 'package:mi_tienda_app/controllers/providers/products_provider.dart';
import 'package:mi_tienda_app/controllers/services/notification_service.dart';
import 'package:mi_tienda_app/controllers/services/user_database_service.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/shipment_method.dart';
import 'package:mi_tienda_app/models/store_user.dart';
import 'package:provider/provider.dart';

class CustomerCheckoutShipmentScreen extends StatefulWidget {
  const CustomerCheckoutShipmentScreen({super.key});

  @override
  State<CustomerCheckoutShipmentScreen> createState() =>
      _CustomerCheckoutShipmentScreenState();
}

class _CustomerCheckoutShipmentScreenState
    extends State<CustomerCheckoutShipmentScreen> {
  late CartProvider cartProvider;
  late CustomerOrdersProvider ordersProvider;
  late ProductsProvider productsProvider;
  late AuthenticationProvider authProvider;
  late NotificationService notificationService;
  late UserDatabaseService userDatabaseService;

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
  void initState() {
    super.initState();
    final cartProvider = context.read<CartProvider>();
    cartProvider.getCart();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = context.watch<CartProvider>();
    ordersProvider = context.watch<CustomerOrdersProvider>();
    productsProvider = context.watch<ProductsProvider>();
    notificationService = GetIt.instance.get<NotificationService>();
    authProvider = context.watch<AuthenticationProvider>();
    userDatabaseService = GetIt.instance.get<UserDatabaseService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de envío'),
      ),
      body: StreamBuilder<Cart>(
          stream: cartProvider.cart,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final Cart cart = snapshot.data!;
            return StreamBuilder<IUser>(
                stream: userDatabaseService.getStreamUser(authProvider.user.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final Customer customer = snapshot.data! as Customer;
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Dirección de envío:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          customer.address,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        const Text(
                          'Seleccionar método de envío',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        RadioListTile(
                          title: const Text('Recogida en tienda'),
                          value: ShipmentMethod.recogidaEnTienda,
                          groupValue: ordersProvider.selectedShipmentMethod,
                          onChanged: (value) {
                            setState(() {
                              ordersProvider
                                  .setShipmentMethod(value as ShipmentMethod);
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Envío a domicilio'),
                          value: ShipmentMethod.envioADomicilio,
                          groupValue: ordersProvider.selectedShipmentMethod,
                          onChanged: (value) {
                            setState(() {
                              ordersProvider
                                  .setShipmentMethod(value as ShipmentMethod);
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed:
                              ordersProvider.selectedShipmentMethod != null &&
                                      cart.items.isNotEmpty
                                  ? () async {
                                      ordersProvider
                                          .createOrder(cart, customer.address)
                                          .then((value) {
                                        if (value) {
                                          productsProvider
                                              .decreaseStockWithOrder(cart);
                                          cartProvider.clearCart();
                                          notificationSuccess(
                                              'Pedido realizado correctamente. Ve a Mis pedidos para ver el estado del pedido.');
                                          Navigator.pushNamed(
                                              context, '/customer-home');
                                        } else {
                                          notificationError(
                                              'Error al realizar el pedido');
                                        }
                                      });
                                    }
                                  : null,
                          child: const Text('Realizar pedido'),
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
