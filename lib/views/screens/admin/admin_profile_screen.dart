import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/views/widgets/section_togglable_field.dart';
import 'package:provider/provider.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late AppDataProvider _appDataProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isEditingStorageData = false;
  @override
  Widget build(BuildContext context) {
    _appDataProvider = context.watch<AppDataProvider>();

    return Padding(
        padding: const EdgeInsets.only(bottom: 40, top: 10),
        child: ListView(children: [_buildStoreDataSection()]));
  }

  _buildStoreDataSection() {
    return Section(
      onPressed: () {
        setState(() {
          _isEditingStorageData = !_isEditingStorageData;
        });
      },
      title: "Datos de la tienda",
      isEditing: _isEditingStorageData,
      update: () {
        _appDataProvider.changeAppData(
            _nameController.text, _addressController.text);
      },
      children: [
        TogglableField(
          label: "Nombre",
          icon: Icons.store_mall_directory_outlined,
          value: _appDataProvider.appName,
          controller: _nameController,
          isEditing: _isEditingStorageData,
        ),
        TogglableField(
          label: "Direccion",
          icon: Icons.location_on_outlined,
          value: _appDataProvider.address,
          controller: _addressController,
          isEditing: _isEditingStorageData,
        ),
      ],
    );
  }
}


//TODO implementar la seccion para seleccionar el tema de la tienda y actualizarlo
//TODO implementar la seccion para administrar los distribuidores