import 'package:flutter/material.dart';

class FilterDropdownMenu extends StatelessWidget {

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final IconData icon;
  final String hintText;
  final List<DropdownMenuEntry<String>> entries;
  final String? initial;

  const FilterDropdownMenu({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    required this.icon,
    required this.hintText,
    this.entries = const [],
    this.initial = null
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: DropdownMenu(
        initialSelection: initial,
        expandedInsets: EdgeInsets.zero,
        // requestFocusOnTap: true,
        label: Text(hintText),
        leadingIcon: Icon(icon, size: 24,),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          prefixIconColor: Theme.of(context).textTheme.bodyMedium?.color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        dropdownMenuEntries: entries,
      )
    );
  }
}
