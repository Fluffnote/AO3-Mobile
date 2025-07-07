import 'dart:async';

import 'package:ao3mobile/data/models/History.dart';
import 'package:ao3mobile/data/repositories/ChapterRepo.dart';
import 'package:ao3mobile/data/repositories/WorkRepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ao3mobile/layout/ui/MiscUtils.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import '../data/models/Chapter.dart';
import '../data/models/Work.dart';
import '../layout/ui/core/ExpandedMarkdownBox.dart';


class ReadingView extends StatefulWidget {
  final int workId;
  final int chapterId;
  final int refreshType;
  const ReadingView({super.key, required this.workId, required this.chapterId, this.refreshType = 1});

  @override
  State<ReadingView> createState() => _ReadingView();
}

class _ReadingView extends State<ReadingView> {
  final WorkRepo workRepo = new WorkRepo();
  final ChapterRepo chapterRepo = new ChapterRepo();

  late Future<Chapter> chapter;
  late final Future<Work> work;
  late final _scrollController;
  double _savedScrollOffset = 0;
  double _scrollOffset = 0;
  double _scrollMax = 0;
  double _scrollSaveDistance = 100;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    work = workRepo.getWork(widget.workId, 0);
    chapter = chapterRepo.getChapter(widget.workId, widget.chapterId, widget.refreshType);
  }

  Future<void> setup() async {

    History history = await chapterRepo.addHistoryEntry(await work, await chapter);

    _scrollOffset = (history.pos);
    _scrollMax = (history.maxPos);
    if (_scrollController.positions.isNotEmpty && !loaded) {
      _scrollController.jumpTo(_scrollOffset.toDouble());
      loaded = true;
    }

    _scrollController.addListener(scrollListen);
  }

  void scrollListen() {
    _scrollOffset = _scrollController.offset;
    if (_scrollController.positions.isNotEmpty) _scrollMax = _scrollController.positions[0].maxScrollExtent;
    if ((_scrollOffset - _savedScrollOffset).abs() >= _scrollSaveDistance) {
      _savedScrollOffset = _scrollOffset;
      chapterRepo.updateHistoryPos(widget.workId, widget.chapterId, _savedScrollOffset, _scrollMax);
      if (kDebugMode) print("saved spot");
    }
    setState(() {});
  }


  @override
  void dispose() {
    chapterRepo.updateHistoryPos(widget.workId, widget.chapterId, _scrollOffset, _scrollMax);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chapter,
        builder: (context, snapshot) {
            if (snapshot.hasData) {
              setup();

              return Scaffold(
                  appBar: AppBar(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Theme.of(context).primaryColor,
                    ),
                    toolbarHeight: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                body: Scrollbar(
                  controller: _scrollController,
                  child: CustomScrollView(
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
                            onPressed: () {
                              chapter = chapterRepo.getChapter(widget.workId, widget.chapterId, 2);
                            },
                          )
                        ],
                        backgroundColor: Theme.of(context).primaryColor,
                        floating: true,
                        pinned: false,
                        elevation: 1000.0,
                      ),
                      ReadingViewContent(chapter: snapshot.data!)
                    ],
                  ),
                )
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
    // Build chapter header
    String chapterHead = "";
    if (widget.chapter.title.isNotEmpty) {
      if (widget.chapter.id != -1 && widget.chapter.num.isNotEmpty) {
        chapterHead += "${widget.chapter.num}. ";
      }
      chapterHead += widget.chapter.title;
    }
    else {
      chapterHead = "Chapter ${widget.chapter.num}";
    }


    return SliverList(delegate: SliverChildListDelegate([
      Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 30),
            child: Text(chapterHead, style: Theme.of(context).textTheme.headlineSmall),
          ),
          Visibility(
              visible: widget.chapter.summary.isNotEmpty,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                  )
              )
          ),
          Visibility(
              visible: widget.chapter.notes.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
              )
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: const SizedBox(height: 30)
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: GptMarkdown(widget.chapter.body)
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: const SizedBox(height: 50)
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: const Divider()
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: const SizedBox(height: 10)
          ),
          Visibility(
            visible: widget.chapter.id != 0,
            child: Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 45),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingView(workId: widget.chapter.workId, chapterId: widget.chapter.nextId)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Next Chapter", style: Theme.of(context).textTheme.titleMedium)],),
                  ),
                )
            )
          )
        ],
      )
    ]));
  }
}



