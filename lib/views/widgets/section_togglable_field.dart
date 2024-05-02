import 'package:flutter/material.dart';
import 'package:mi_tienda_app/global/input_regex_validation.dart';

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
  final _formKey = GlobalKey<FormState>();
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
                            if (_formKey.currentState!.validate()) {
                              widget.update!();
                              widget.onPressed!();
                            }
                          } else {
                            widget.onPressed!();
                          }
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
        Form(key: _formKey, child: Column(children: widget.children))
      ],
    );
  }
}

class TogglableField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final TextEditingController controller;
  final bool? isEditing;
  final StringOrNullFunction validator;
  const TogglableField(
      {super.key,
      required this.label,
      required this.value,
      required this.icon,
      required this.validator,
      required this.controller,
      this.isEditing});

  @override
  Widget build(BuildContext context) {
    controller.text = value;
    TextFormField formFiled = TextFormField(
        controller: controller,
        validator: (value) => validator(value!),
        decoration:
            InputDecoration(labelText: value, enabled: isEditing ?? false),
        autovalidateMode: AutovalidateMode.onUserInteraction);

    return ListTile(
      tileColor: null,
      leading: Icon(icon),
      title: Text(
        label,
      ),
      subtitle: formFiled,
    );
  }
}
