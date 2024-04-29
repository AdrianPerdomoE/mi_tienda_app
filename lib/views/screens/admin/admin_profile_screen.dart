import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';

import 'package:mi_tienda_app/controllers/services/distributor_database_service.dart';

import 'package:mi_tienda_app/models/custom_theme.dart';
import 'package:mi_tienda_app/models/distributor.dart';
import 'package:mi_tienda_app/views/widgets/add_distributor_dialog.dart';

import 'package:mi_tienda_app/views/widgets/rounded_image.dart';
import 'package:mi_tienda_app/views/widgets/section_togglable_field.dart';
import 'package:mi_tienda_app/views/widgets/star_list_generator.dart';
import 'package:provider/provider.dart';

import '../../widgets/confirm_delete_element_dialog.dart';
import '../../widgets/info_removable_item.dart';
import '../../widgets/section_add_button.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late AppDataProvider _appDataProvider;
  late DistributorDatabaseService _distributorDatabaseService;
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
    _distributorDatabaseService =
        GetIt.instance.get<DistributorDatabaseService>();
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
    return StreamBuilder(
      stream: _distributorDatabaseService.distributors,
      builder: (context, snapshot) {
        return SectionAddButton(
            onAdd: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddDistributorDialog();
                  });
            },
            title: "Distribuidores",
            children: _buildDistributorList(snapshot));
      },
    );
  }

  List<Widget> _buildDistributorList(AsyncSnapshot snap) {
    if (snap.error != null) {
      return [Text("Error al cargar los distribuidores ${snap.error}")];
    }
    switch (snap.connectionState) {
      case ConnectionState.waiting:
        return [const CircularProgressIndicator()];
      case ConnectionState.done || ConnectionState.active:
        if (snap.data.isEmpty) {
          return [const Text("No hay distribuidores")];
        }
        List<Widget> items = [];
        snap.data.sort(
            (Distributor a, Distributor b) => b.rating.compareTo(a.rating));
        snap.data.forEach(
          (doc) {
            items.add(InfoRemovableItem(
              itemData: _buildDistributorItemData(doc),
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDeleteElementDialog(
                        content:
                            "¿Estas seguro de eliminar al distribuidor ${doc.name}?",
                        onDelete: () {
                          _distributorDatabaseService.deleteDistributor(doc.id);
                        });
                  },
                );
              },
              onInfo: () {},
            ));
          },
        );
        return items;
      case ConnectionState.none:
        return [const Text("No hay conexion a internet")];
    }
  }

  Widget _buildDistributorItemData(Distributor distributor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(distributor.name, style: const TextStyle(fontSize: 16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedImageNetwork(imagePath: distributor.imageUrl, imageSize: 60),
            ...starListGenerator(5, distributor.rating, 25)
          ],
        ),
      ],
    );
  }
}
