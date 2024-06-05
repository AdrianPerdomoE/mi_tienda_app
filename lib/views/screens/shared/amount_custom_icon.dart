import 'package:flutter/material.dart';
import 'package:mi_tienda_app/controllers/providers/app__data_provider.dart';
import 'package:provider/provider.dart';

class AmountCustomIcon extends StatefulWidget {
  final Widget underElement;
  final int amount;
  const AmountCustomIcon(
      {super.key, required this.underElement, required this.amount});

  @override
  State<AmountCustomIcon> createState() => _AmountCustomIconState();
}

class _AmountCustomIconState extends State<AmountCustomIcon> {
  late AppDataProvider appDataProvider;

  @override
  Widget build(BuildContext context) {
    appDataProvider = context.watch<AppDataProvider>();
    return Stack(
      children: [
        widget.underElement,
        widget.amount == 0
            ? const SizedBox()
            : Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: appDataProvider.accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    widget.amount.toString(),
                    style: TextStyle(
                      color: appDataProvider.backgroundColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
      ],
    );
  }
}
