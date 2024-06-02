import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/order_provider.dart';
import 'package:mi_tienda_app/controllers/services/navigation_service.dart';
import 'package:mi_tienda_app/controllers/services/user_database_service.dart';
import 'package:mi_tienda_app/models/order.dart';
import 'package:mi_tienda_app/models/order_states.dart';
import 'package:mi_tienda_app/models/store_user.dart';
import 'package:provider/provider.dart';

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
                      title: Text("Loading..."),
                      subtitle: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final user = snapshot.data;
                  if (user == null) {
                    return const ListTile(
                      title: Text("User not found"),
                    );
                  }
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    leading: Container(
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
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () {
                              _navigationService.navigateToPage(
                                const UserSettingsScreen(),
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
                      offset: const Offset(-30, 40),
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

class OrderListScreen extends StatefulWidget {
  final List<Order> orders;
  const OrderListScreen({super.key, required this.orders});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late List<bool> _data;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _data = List.generate(widget.orders.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pedidos"),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _data[index] = isExpanded;
              });
            },
            children: widget.orders
                .map<ExpansionPanel>((order) => ExpansionPanel(
                      isExpanded: _data[widget.orders.indexOf(order)],
                      headerBuilder: (context, isExpanded) {
                        DateTime date = order.createdAt.toDate().toLocal();
                        return ListTile(
                          title: Text(
                              "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}:${date.second} - Total: ${order.amount()} \$"),
                          subtitle: Row(
                            children: [
                              const Text(
                                "Estado: ",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              DropdownButton<OrderStates>(
                                value: order.state,
                                elevation: 16,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (state) {
                                  setState(() {
                                    order.state = state!;

                                    context.read<OrderProvider>().update(order);
                                  });
                                },
                                items: OrderStates.values
                                    .map((state) => DropdownMenuItem(
                                          value: state,
                                          child: Text(state.name),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        );
                      },
                      body: Wrap(
                        children: order.items.map((item) {
                          return ListTile(
                            title: Text(item.productName),
                            subtitle: Text(
                                "Precio unitario (descuento incluido): ${item.price * (1 - item.discount)} \$"),
                            leading: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                image: DecorationImage(
                                  image: NetworkImage(item.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            trailing: Text("Cantidad: ${item.quantity}",
                                style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Center(
        child: Text("Settings"),
      ),
    );
  }
}
