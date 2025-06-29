import 'package:flutter/material.dart';

class FilterTextField extends StatelessWidget {

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final IconData icon;
  final String hintText;

  const FilterTextField({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    required this.icon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: TextField(
        // style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        decoration: InputDecoration(
          // isDense: true,
          // filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          prefixIcon: Icon(icon),
          prefixIconColor: Theme.of(context).textTheme.bodyMedium?.color,
          labelText: hintText,
          // hintText: hintText,
          // hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
