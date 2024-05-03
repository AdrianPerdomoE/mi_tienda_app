import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:provider/provider.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;
  late AppDataProvider appDataProvider;
  RoundedButton(
      {super.key,
      required this.name,
      required this.height,
      required this.width,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: appDataProvider.primaryColor,
        borderRadius: BorderRadius.circular(height * 0.25),
        boxShadow: [
          BoxShadow(
            color: appDataProvider.textColor.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: TextButton(
          child: Text(
            name,
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
          onPressed: () {
            onPressed();
          }),
    );
  }
}
