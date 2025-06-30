import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ExpandedMarkdownBox extends StatefulWidget {
  final String body;
  final int limit;
  final bool showButton;
  final bool stayOpen;
  const ExpandedMarkdownBox({super.key, required this.body, this.limit = 150, this.showButton = true, this.stayOpen = false});

  @override
  State<ExpandedMarkdownBox> createState() => _ExpandedMarkdownBoxState();
}


class _ExpandedMarkdownBoxState extends State<ExpandedMarkdownBox> {
  late bool longerThanLimit = false;
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.body.length>widget.limit) { longerThanLimit = true; }
    else { longerThanLimit = false; }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (widget.body.length>widget.limit) { longerThanLimit = true; }
    else { longerThanLimit = false; }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (longerThanLimit) {
      String data = "";

      if (!expanded && !widget.stayOpen && widget.body.length > widget.limit) {
        data = "${widget.body.substring(0, widget.limit)}...";
      }
      else {
        data = widget.body;
      }

      list.add(GptMarkdown(data));

      if (widget.showButton) {
        list.add(
          InkWell(
            onTap: (){ setState(() { expanded = !expanded; });},
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(!expanded?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up, size: 26,)],),
            )
          )
        );
      }
    }
    else {
      list.add(GptMarkdown(widget.body));
    }

    return Container(child: Column(children: list));
  }
}