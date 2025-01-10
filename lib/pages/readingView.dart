import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ao3mobile/classes/MiscUtils.dart';
import '../classes/Chapter.dart';


class ReadingView extends StatefulWidget {
  final int workId;
  final int chapterId;
  const ReadingView({super.key, required this.workId, required this.chapterId});

  @override
  State<ReadingView> createState() => _ReadingView();
}

class _ReadingView extends State<ReadingView> {
  late Future<Chapter> chapter;
  late final _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    chapter = getChapter(widget.workId, widget.chapterId);
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   chapter = getChapter(widget.workId, widget.chapterId);
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chapter,
        builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                body: CustomScrollView(
                  controller: _scrollController,
                  scrollBehavior: const MaterialScrollBehavior(),
                  slivers: [
                    SliverAppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () { Navigator.pop(context); },
                      ),
                      title: Text(snapshot.data!.workTitle),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: () {},
                        )
                      ],
                      backgroundColor: Theme.of(context).primaryColor,
                      floating: true,
                      pinned: false,
                    ),
                    ReadingViewContent(chapter: snapshot.data!)
                  ],
                ),
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

class ReadingViewContent extends StatefulWidget {
  final Chapter chapter;
  const ReadingViewContent({super.key, required this.chapter});

  @override
  State<ReadingViewContent> createState() => _ReadingViewContentState();
}

class _ReadingViewContentState extends State<ReadingViewContent> {
  late Future<Chapter> chapter;

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildListDelegate([
      Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Text(widget.chapter.title.isNotEmpty?"${widget.chapter.num}${widget.chapter.num.isNotEmpty?". ":""}${widget.chapter.title}":"Chapter ${widget.chapter.num}",
          style: Theme.of(context).textTheme.headlineSmall,),
      ),
      Visibility(
        visible: widget.chapter.summary.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text("Summary: ", style: Theme.of(context).textTheme.titleMedium,),
            ),
            ExpandedMarkdownBox(body: widget.chapter.summary),
            const Divider(),
          ],
        ),
      ),
      Visibility(
        visible: widget.chapter.notes.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text("Notes: ", style: Theme.of(context).textTheme.titleMedium,),
            ),
            ExpandedMarkdownBox(body: widget.chapter.notes),
            const Divider(),
          ],
        ),
      ),
      const SizedBox(height: 30,),
      MarkdownBody(data: widget.chapter.body),
      const SizedBox(height: 50,),
      // Text(chapter.nextId.toString(), style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      const SizedBox(height: 10,),
      InkWell(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingView(workId: widget.chapter.workId, chapterId: widget.chapter.id)));
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Next Chapter", style: Theme.of(context).textTheme.titleMedium)],),
        ),
      )
    ]));
  }
}



