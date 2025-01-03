import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ExpandedMarkdownBox extends StatefulWidget {
  final String body;
  final int limit;
  const ExpandedMarkdownBox({super.key, required this.body, this.limit = 150});

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
    return Container(
      child: !longerThanLimit?MarkdownBody(data: widget.body,):Column(
        children: [
          MarkdownBody(data: !expanded&&widget.body.length>widget.limit?"${widget.body.substring(0, widget.limit)}...":widget.body,),
          InkWell(
            onTap: (){ setState(() { expanded = !expanded; });},
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(!expanded?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up, size: 26,)],),
            ),
          )
        ],
      ),
    );
  }
}

class FutureErrorView extends StatelessWidget {
  final AsyncSnapshot snapshot;
  const FutureErrorView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () { Navigator.pop(context); },
          ),
          forceMaterialTransparency: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(snapshot.error.toString(), style: const TextStyle(fontSize: 14.0, color: Color.fromRGBO(226, 70, 70, 1.0)),),
              Text(snapshot.stackTrace.toString(), style: const TextStyle(fontSize: 14.0, color: Color.fromRGBO(226, 70, 70, 1.0)),),
            ],
          ),
        ),
    );
  }
}

class FutureErrorBody extends StatelessWidget {
  final AsyncSnapshot snapshot;
  const FutureErrorBody({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container( padding: const EdgeInsets.all(5.0), child: Text('$snapshot', style: const TextStyle(fontSize: 14.0, color: Color.fromRGBO(226, 70, 70, 1.0)),),);
  }
}


class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () { Navigator.pop(context); },
          ),
          forceMaterialTransparency: true,
        ),
        body: const Center(child: CircularProgressIndicator(),)
    );
  }
}


