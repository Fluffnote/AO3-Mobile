import 'package:flutter/material.dart';



class IconLabel extends StatelessWidget {

  final IconData icon;
  final String text;
  final TextStyle? style;
  final double size;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool wrap;
  final double spacing;
  final bool right;

  const IconLabel({
    super.key,
    required this.icon,
    required this.text,
    this.style,
    this.size = 14.0,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.wrap = false,
    this.spacing = 5.0,
    this.right = false
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (text.isNotEmpty) {
      if (!right) {
        list.add(Icon(icon, size: size));
        list.add(SizedBox(width: spacing));
      }

      if (wrap) {
        list.add(Expanded(child: Text(text, style: (style!=null)? style: Theme.of(context).textTheme.labelSmall)));
      }
      else {
        list.add(Text(text, style: (style!=null)? style: Theme.of(context).textTheme.labelSmall));
      }

      if (right) {
        list.add(SizedBox(width: spacing));
        list.add(Icon(icon, size: size));
      }
    }

    return Visibility(
      visible: text.isNotEmpty,
      child: Container(
        margin: margin,
        padding: padding,
        child: Row( children: list ),
      )
    );
  }
}
