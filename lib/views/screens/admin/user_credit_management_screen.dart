import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/services/user_database_service.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';
import 'package:mi_tienda_app/models/order.dart';
import 'package:mi_tienda_app/models/store_user.dart';
import 'package:mi_tienda_app/views/widgets/section_togglable_field.dart';

import '../../widgets/rounded_image.dart';

class UserCreditManagement extends StatefulWidget {
  final Customer user;
  final List<Order> orders;
  const UserCreditManagement(
      {super.key, required this.user, required this.orders});

  @override
  State<UserCreditManagement> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserCreditManagement> {
  final _scrollController = ScrollController();
  TextEditingController _maxCreditAmount = TextEditingController();
  UserDatabaseService _userDatabaseService =
      GetIt.instance.get<UserDatabaseService>();
  bool _isEditing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestión de credito del usuario"),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            controller: _scrollController,
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedImageNetwork(
                          imagePath: widget.user.imageUrl, imageSize: 120),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ListView(
                      children: [
                        Section(
                            isEditing: _isEditing,
                            onPressed: () {
                              setState(() {
                                _isEditing = !_isEditing;
                              });
                            },
                            update: () {
                              widget.user.maxCredit =
                                  double.parse(_maxCreditAmount.text);
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
                            ]),
                        Section(title: "Pedidos fiados", children: [])
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
