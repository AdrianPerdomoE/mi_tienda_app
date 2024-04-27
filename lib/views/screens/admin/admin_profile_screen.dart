import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:mi_tienda_app/models/custom_theme.dart';
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
  bool _isEditingStorageTheme = false;
  late int _currentTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appDataProvider = Provider.of<AppDataProvider>(context);
    _currentTheme = _appDataProvider.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 40, top: 10),
        child: ListView(children: [
          _buildStoreDataSection(),
          _buildStoreThemeSection(),
          _buildDistributorsSection()
        ]));
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

  _buildStoreThemeSection() {
    return Section(
      onPressed: () {
        setState(() {
          _isEditingStorageTheme = !_isEditingStorageTheme;
        });
      },
      title: "Tema de la tienda",
      isEditing: _isEditingStorageTheme,
      update: () {
        _appDataProvider.changeTheme(_currentTheme);
      },
      children: _isEditingStorageTheme
          ? _buildThemeOptions()
          : [_buildThemeOption(_appDataProvider.currentTheme)],
    );
  }

  List<Widget> _buildThemeOptions() {
    List<Widget> options = [];
    for (int i = 0; i < _appDataProvider.themes.length; i++) {
      options.add(_buildThemeOption(i));
    }
    return options;
  }

  Widget _buildThemeOption(int index) {
    return CheckboxListTile(
      title: Text("Tema ${index + 1}"),
      value: _currentTheme == index,
      secondary: const Icon(Icons.palette_outlined),
      subtitle: _generateThemePalette(_appDataProvider.themes[index]),
      onChanged: (value) {
        setState(() {
          _currentTheme = index;
        });
      },
    );
  }

  _generateThemePalette(CustomTheme theme) {
    return Row(
      children: [
        Container(
          color: theme.primary,
          width: 20,
          height: 20,
        ),
        Container(
          color: theme.secondary,
          width: 20,
          height: 20,
        ),
        Container(
          color: theme.accent,
          width: 20,
          height: 20,
        ),
        Container(
          color: theme.background,
          width: 20,
          height: 20,
        ),
        Container(
          color: theme.text,
          width: 20,
          height: 20,
        ),
      ],
    );
  }

  _buildDistributorsSection() {
    return Section(
      onPressed: () {},
      title: "Distribuidores",
      children: [
        ListTile(
          title: Text("Distribuidor 1"),
        ),
        ListTile(
          title: Text("Distribuidor 2"),
        ),
        ListTile(
          title: Text("Distribuidor 3"),
        ),
      ],
    );
  }
}

//TODO implementar la seccion para administrar los distribuidores
