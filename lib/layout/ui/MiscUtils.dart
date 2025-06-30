import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<void> openWebPage(String url) async {
  Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) throw Exception('Could not launch $uri');
}


