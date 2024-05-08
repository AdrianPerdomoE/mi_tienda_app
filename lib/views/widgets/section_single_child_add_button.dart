import 'package:flutter/material.dart';

class SectionChildlessAddButton extends StatelessWidget {
  final String title;

  //Debe ser funcion que controle el evento de agregar elementos de la seccion.
  // Estas funciones deberian implementar un ShowDialog para realizar la accion de agregar
  // Children debe ser una lista de widgets que representan los elementos de la seccion
  final Function()? onAdd;

  const SectionChildlessAddButton({
    super.key,
    required this.title,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: ElevatedButton(
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
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
