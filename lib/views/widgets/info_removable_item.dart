import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/app__data_provider.dart';

class InfoRemovableItem extends StatelessWidget {
  final Widget itemData;
  final Function? onInfo;
  final Function? onDelete;
  late AppDataProvider _appDataProvider;
  InfoRemovableItem(
      {super.key, required this.itemData, this.onInfo, this.onDelete});

  @override
  Widget build(BuildContext context) {
    _appDataProvider = context.watch<AppDataProvider>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        horizontalTitleGap: BorderSide.strokeAlignInside,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _appDataProvider.primaryColor, width: 2),
        ),
        title: itemData,
        titleAlignment: ListTileTitleAlignment.bottom,
        leading: onInfo != null
            ? IconButton(
                icon: const Icon(Icons.info, color: Colors.blue, size: 30),
                onPressed: () {
                  onInfo!();
                },
              )
            : null,
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () {
                  onDelete!();
                },
              )
            : null,
      ),
    );
  }
}
