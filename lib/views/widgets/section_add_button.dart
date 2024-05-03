import 'package:flutter/material.dart';

class SectionAddButton extends StatelessWidget {
  final String title;
  final List<Widget> children;
  //Debe ser funcioN que controle el evento de agregar elementos de la seccion.
  // Estas funciones deberian implementar un ShowDialog para realizar la accion de agregar
  // Children debe ser una lista de widgets que representan los elementos de la seccion
  final Function()? onAdd;

  const SectionAddButton({
    super.key,
    required this.title,
    required this.children,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: null,
          title: Text(
            title,
          ),
          trailing: ElevatedButton(
              onPressed: onAdd == null
                  ? null
                  : () {
                      onAdd!();
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Agregar',
                style: TextStyle(fontSize: 12),
              )),
        ),
        ...children
      ],
    );
  }
}
