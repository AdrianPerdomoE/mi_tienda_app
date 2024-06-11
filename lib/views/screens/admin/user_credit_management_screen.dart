import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/user_database_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
import 'package:mi_tienda_app/models/order.dart';
import 'package:mi_tienda_app/models/order_states.dart';
import 'package:mi_tienda_app/models/store_user.dart';
import 'package:mi_tienda_app/views/widgets/order_expasion_panel_list.dart';
import 'package:mi_tienda_app/views/widgets/section_togglable_field.dart';
import 'package:provider/provider.dart';

import '../../../controllers/providers/order_provider.dart';
import '../../widgets/rounded_image.dart';

class UserCreditManagement extends StatefulWidget {
  final Customer user;
  final List<Order> orders;
  const UserCreditManagement(
      {super.key, required this.user, required this.orders});

  @override
  State<UserCreditManagement> createState() => _UserCreditManagement();
}

class _UserCreditManagement extends State<UserCreditManagement> {
  late List<Order> creditOrders;
  final _scrollController = ScrollController();
  final TextEditingController _maxCreditAmount = TextEditingController();
  final UserDatabaseService _userDatabaseService =
      GetIt.instance.get<UserDatabaseService>();
  bool _isEditing = false;
  @override
  Widget build(BuildContext context) {
    creditOrders = widget.orders
        .where((order) => order.state == OrderStates.fiado)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de credito del usuario"),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          _buildPersonalInfo(),
          _buildCreditSection(),
          _buildOrdersSection()
        ],
      ),
    );
  }

  _buildOrdersSection() {
    return Section(title: "Pedidos fiados ${creditOrders.length}", children: [
      ListTile(
        title: const Text("Total fiado al usuario:"),
        subtitle: Text(creditOrders.isEmpty
            ? "0 \$"
            : "${creditOrders.fold(0.0, (previousValue, element) => previousValue + element.amount())} \$"),
      ),
      OrderExpansionPanelList(
        orders: creditOrders,
        onOrderStateChange: (order, state) {
          setState(() {
            order.state = state;

            context.read<OrderProvider>().update(order);
          });
        },
      )
    ]);
  }

  _buildCreditSection() {
    return Section(
        isEditing: _isEditing,
        onPressed: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        update: () {
          widget.user.maxCredit = double.parse(_maxCreditAmount.text);
          _userDatabaseService.updateUserData(widget.user);
        },
        title: "Credito",
        children: [
          TogglableField(
            controller: _maxCreditAmount,
            icon: Icons.monetization_on,
            label: "Monto maximo a fiar",
            validator: InputRegexValidator.validateAmount,
            value: widget.user.maxCredit.toString(),
            isEditing: _isEditing,
            keyboardType: TextInputType.number,
          )
        ]);
  }

  _buildPersonalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedImageNetwork(
              imagePath: widget.user.imageUrl, imageSize: 120),
        ),
        const SizedBox(width: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                Text(
                  widget.user.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.email, size: 16),
                Text(widget.user.email,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )
      ],
    );
  }
}
