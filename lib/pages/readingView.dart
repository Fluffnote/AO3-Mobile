import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ao3mobile/classes/miscUtils.dart';
import '../classes/Chapter.dart';
import '../classes/Work.dart';


class ReadingView extends StatefulWidget {
  final Work work;
  final int chapterId;
  const ReadingView({super.key, required this.work, required this.chapterId});

  @override
  State<ReadingView> createState() => _ReadingView();
}

class _ReadingView extends State<ReadingView> {
  late Future<Chapter> chapter;

  @override
  void initState() {
    super.initState();
    chapter = getChapter(widget.work.id, widget.chapterId);
  }

  @override
  void reassemble() {
    super.reassemble();
    chapter = getChapter(widget.work.id, widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chapter,
        builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () { Navigator.pop(context); },
                    ),
                    title: Text(widget.work.title),
                    backgroundColor: Theme.of(context).primaryColor,
                    forceMaterialTransparency: true,
                  ),
                  body: ReadingViewContent(chapter: snapshot.data!)
              );
            } else if (snapshot.hasError) {
              print(snapshot);
              return FutureErrorView(snapshot: snapshot);
            }
            return const LoadingView();
          },
    );
  }
}

class ReadingViewContent extends StatelessWidget {
  final Chapter chapter;
  const ReadingViewContent({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Text(chapter.title.isNotEmpty?"${chapter.num}. ${chapter.title}":"Chapter ${chapter.num}", style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Visibility(
            visible: chapter.summary.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text("Summary: ", style: Theme.of(context).textTheme.titleMedium,),
                ),
                ExpandedMarkdownBox(body: chapter.summary),
                const Divider(),
              ],
            ),
          ),
          Visibility(
            visible: chapter.notes.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text("Notes: ", style: Theme.of(context).textTheme.titleMedium,),
                ),
                ExpandedMarkdownBox(body: chapter.notes),
                const Divider(),
              ],
            ),
          ),
          const SizedBox(height: 30,),
          MarkdownBody(data: chapter.body),
          const SizedBox(height: 30,),

        ],
      ),
    );
  }
}



