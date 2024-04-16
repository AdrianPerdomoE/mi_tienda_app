import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/models/store_user.dart';
import 'package:provider/provider.dart';

//services
import '../../../controllers/services/user_database_service.dart';
//providers
import '../../../controllers/providers/authentication_provider.dart';
//widgets
import '../../widgets/rounded_image.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late UserDatabaseService _userDatabaseService;
  late AuthenticationProvider _authProvider;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController maxAmountController = TextEditingController();

  bool isEditingPersonalData = false;
  bool isEditingContactInfo = false;
  bool isEditingShippingInfo = false;
  bool isEditingCreditInfo = false;
  @override
  Widget build(BuildContext context) {
    _userDatabaseService = GetIt.instance.get<UserDatabaseService>();
    _authProvider = context.read<AuthenticationProvider>();
    return StreamBuilder(
      stream: _userDatabaseService.getStreamUser(_authProvider.user.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return _buildUi(snapshot.data as Customer);
      },
    );
  }

  _buildUi(Customer customer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 10),
      child: ListView(
        children: [
          RoundedImageNetwork(
            imagePath: customer.imageUrl,
            imageSize: 100,
          ),
          _buildPersonalDataSection(customer),
          const Divider(),
          _buildContactInfoSection(customer),
          const Divider(),
          _buildShippingInfoSection(customer),
          const Divider(),
          _buildCreditInfo(customer),
          const StyledElevatedButton(label: 'Cambiar contraseña'),
        ],
      ),
    );
  }

  void updateUserData(Customer customer) {
    customer.name = nameController.text;
    customer.address = addressController.text;
    customer.maxCredit = double.parse(maxAmountController.text);
    _userDatabaseService.updateUserData(customer);
  }

  Widget _buildPersonalDataSection(Customer customer) {
    return Section(
      title: 'Datos Personales',
      update: () {
        updateUserData(customer);
      },
      onPressed: () {
        setState(() {
          isEditingPersonalData = !isEditingPersonalData;
        });
      },
      isEditing: isEditingPersonalData,
      children: [
        TogglableField(
          label: 'Nombre',
          value: customer.name,
          icon: Icons.person_pin,
          controller: nameController,
          isEditing: isEditingPersonalData,
        )
      ],
    );
  }

  Widget _buildShippingInfoSection(Customer customer) {
    return Section(
      title: 'Datos de Envío',
      update: () {
        updateUserData(customer);
      },
      onPressed: () {
        setState(() {
          isEditingShippingInfo = !isEditingShippingInfo;
        });
      },
      isEditing: isEditingShippingInfo,
      children: [
        TogglableField(
          label: 'Dirección de residencia',
          value: customer.address,
          icon: Icons.house,
          controller: addressController,
          isEditing: isEditingShippingInfo,
        )
      ],
    );
  }

  Widget _buildContactInfoSection(Customer customer) {
    return Section(
      title: 'Datos de Contacto',
      children: [
        TogglableField(
          label: 'Correo electrónico',
          value: customer.email,
          icon: Icons.mail,
          controller: emailController,
        ),
      ],
    );
  }

  Widget _buildCreditInfo(Customer customer) {
    return Section(title: "Datos de credito", children: [
      TogglableField(
        label: "Monto maximo a fiar",
        value: customer.maxCredit.toString(),
        icon: Icons.monetization_on_sharp,
        controller: maxAmountController,
      )
    ]);
  }
}

class Section extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Function? onPressed;
  final bool? isEditing;
  final Function? update;
  const Section(
      {super.key,
      required this.title,
      required this.children,
      this.onPressed,
      this.isEditing,
      this.update});

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: null,
          title: Text(
            widget.title,
          ),
          trailing: widget.isEditing != null
              ? ElevatedButton(
                  onPressed: widget.onPressed == null
                      ? () {}
                      : () {
                          if (widget.isEditing!) {
                            widget.update!();
                          }
                          widget.onPressed!();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    widget.isEditing! ? 'Guardar' : 'Editar',
                    style: const TextStyle(fontSize: 12),
                  ))
              : null,
        ),
        ...widget.children
      ],
    );
  }
}

class StyledElevatedButton extends StatelessWidget {
  final String label;
  const StyledElevatedButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size(200, 40),
        ),
        child: Text(label),
      ),
    );
  }
}

class TogglableField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final TextEditingController controller;
  final bool? isEditing;

  const TogglableField(
      {super.key,
      required this.label,
      required this.value,
      required this.icon,
      required this.controller,
      this.isEditing});

  @override
  Widget build(BuildContext context) {
    controller.text = value;
    return ListTile(
      tileColor: null,
      leading: Icon(icon),
      title: Text(
        label,
      ),
      subtitle: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: value,
        ),
        enabled: isEditing ?? false,
      ),
    );
  }
}
