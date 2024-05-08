import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:provider/provider.dart';

class RoundedButton extends StatefulWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;

  const RoundedButton(
      {super.key,
      required this.name,
      required this.height,
      required this.width,
      required this.onPressed});

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  late AppDataProvider appDataProvider;

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: appDataProvider.primaryColor,
        borderRadius: BorderRadius.circular(widget.height * 0.25),
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
            widget.name,
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
          onPressed: () {
            widget.onPressed();
          }),
    );
  }
}
