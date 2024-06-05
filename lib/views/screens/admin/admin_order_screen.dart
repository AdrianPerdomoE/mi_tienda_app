import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/order_provider.dart';
import 'package:mi_tienda_app/controllers/services/navigation_service.dart';
import 'package:mi_tienda_app/controllers/services/user_database_service.dart';
import 'package:mi_tienda_app/models/order.dart';
import 'package:mi_tienda_app/views/screens/shared/amount_custom_icon.dart';
import 'package:provider/provider.dart';

import '../../../models/store_user.dart';
import 'order_list_screen.dart';
import 'user_credit_management_screen.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  late OrderProvider _orderProvider;
  final UserDatabaseService _userDatabaseService =
      GetIt.instance.get<UserDatabaseService>();
  final NavigationService _navigationService =
      GetIt.instance.get<NavigationService>();
  @override
  Widget build(BuildContext context) {
    _orderProvider = context.watch<OrderProvider>();
    return StreamBuilder(
        stream: _orderProvider.getStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data as List<Order>;
          final ordersByUser = mapOrdersByUser(orders);
          return ListView.builder(
            itemCount: ordersByUser.length,
            itemBuilder: (context, index) {
              final userId = ordersByUser.keys.elementAt(index);
              final userOrders = ordersByUser[userId]!;
              return FutureBuilder(
                future: _userDatabaseService.getUser(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text("Cargando..."),
                      subtitle: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final user = snapshot.data;
                  if (user == null) {
                    return const ListTile(
                      title: Text("Usuario no encontrado"),
                    );
                  }
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    leading: AmountCustomIcon(
                      amount:
                          _orderProvider.getPendingOrdersCountSync(userOrders),
                      underElement: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          image: DecorationImage(
                            image: NetworkImage(user.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () {
                              _navigationService.navigateToPage(
                                UserCreditManagement(
                                    orders: userOrders, user: user as Customer),
                              );
                            },
                            child: const Center(
                              child: Icon(Icons.settings),
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              _navigationService.navigateToPage(
                                OrderListScreen(orders: userOrders),
                              );
                            },
                            child: const Center(
                              child: Icon(Icons.list),
                            ),
                          ),
                        ];
                      },
                      offset: const Offset(-25, 30),
                    ),
                  );
                },
              );
            },
          );
        });
  }
}

Map<String, List<Order>> mapOrdersByUser(List<Order> orders) {
  final Map<String, List<Order>> ordersByUser = {};
  for (final order in orders) {
    if (ordersByUser.containsKey(order.userId)) {
      ordersByUser[order.userId]!.add(order);
    } else {
      ordersByUser[order.userId] = [order];
    }
  }
  return ordersByUser;
}
