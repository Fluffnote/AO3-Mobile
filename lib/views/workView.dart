import 'package:ao3mobile/data/repositories/WorkRepo.dart';
import 'package:ao3mobile/layout/ui/core/IconLabel.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ao3mobile/layout/ui/MiscUtils.dart';
import 'package:ao3mobile/views/readingView.dart';
import 'package:flutter/services.dart';

import '../data/models/Work.dart';
import '../layout/ui/core/ExpandedMarkdownBox.dart';

class WorkView extends StatefulWidget {
  final int workId;
  final int refreshType;
  const WorkView({super.key, required this.workId, this.refreshType = 0 });

  @override
  State<WorkView> createState() => _WorkView();
}

class _WorkView extends State<WorkView> {
  late Future<Work> work;
  late final _scrollController;
  double _scrollOffset = 0;

  final WorkRepo workRepo = new WorkRepo();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    work = workRepo.getWork(widget.workId, widget.refreshType);
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   work = getWork(widget.workId);
  // }
  
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: work,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).primaryColor,
              ),
              toolbarHeight: 0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: CustomScrollView(
              controller: _scrollController,
              scrollBehavior: const MaterialScrollBehavior(),
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () { Navigator.pop(context); },
                  ),
                  title: Visibility(
                    visible: _scrollOffset > 120,
                    child: Text(snapshot.data!.title)
                  ),
                  actions: [
                    // IconButton(
                    //   icon: const Icon(Icons.bookmark_add_outlined),
                    //   onPressed: () {},
                    // ),
                    IconButton(
                      icon: const Icon(Icons.public),
                      onPressed: () {
                        workRepo.openWorkPage(snapshot.data!.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.code),
                      onPressed: () {
                        workRepo.openHTML(snapshot.data!.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    )
                  ],
                  backgroundColor: Theme.of(context).primaryColor,
                  floating: true,
                  pinned: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      systemNavigationBarColor: Theme.of(context).primaryColor
                  ),
                ),
                MainWorkView(work: snapshot.data!)
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


// Main content
class MainWorkView extends StatelessWidget {
  final Work work;
  const MainWorkView({super.key, required this.work});
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          child: Text(work.title, style: Theme.of(context).textTheme.headlineLarge,),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
            child: WorkInfo(work: work)
        ),
        SingleChildScrollView(padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0), child: ExpandedMarkdownBox( body: work.summary, ),),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          child: Text("${work.chapterStats} chapters", style: Theme.of(context).textTheme.bodyLarge,),
        ),
        for (var chapter in work.chapters) ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingView(workId: work.id, chapterId: chapter.id)));
          },
          title: Text("${chapter.num}. ${chapter.title}"),
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          // trailing: Icon(Icons.download),
        ),
        const SizedBox(height: 30,),
      ]),
    );
  }
}

// Expandable info section
class WorkInfo extends StatelessWidget {
  final Work work;
  const WorkInfo({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Column(
          children: [
            Expandable(
                collapsed: Column(
                  children: [
                    Opacity(
                      opacity: 0.7,
                      child: Column(
                        children: [
                          IconLabel(icon: Icons.person, text: work.author, size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(icon: Icons.sensor_occupied, text: work.rating, size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(
                            icon: Icons.warning,
                            text: work.warning,
                            size: 18.0,
                            style: Theme.of(context).textTheme.bodyMedium,
                            wrap: true,
                          ),
                          IconLabel(
                            icon: Icons.grid_view,
                            text: work.fandoms.join(", "),
                            size: 18.0,
                            style: Theme.of(context).textTheme.bodyMedium,
                            wrap: true,
                          ),
                          IconLabel(
                            icon: (work.statusLabel.isNotEmpty)?Icons.check_rounded:Icons.edit,
                            text: (work.statusLabel.isNotEmpty)?" ${work.statusLabel} · ${work.statusDate}":" Published · ${work.publishedDate}",
                            size: 18.0,
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                        ],
                      ),
                    ),
                    ExpandableButton(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.keyboard_arrow_down, size: 26,)],),
                      ),
                    )
                  ],
                ),
                expanded: Column(
                  children: [
                    Opacity(
                      opacity: 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconLabel(icon: Icons.person, text: work.author, size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(icon: Icons.sensor_occupied, text: work.rating, size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(
                            icon: Icons.warning,
                            text: work.warning,
                            size: 18.0,
                            style: Theme.of(context).textTheme.bodyMedium,
                            wrap: true,
                          ),
                          IconLabel(
                            icon: Icons.grid_view,
                            text: work.fandoms.join(", "),
                            size: 18.0,
                            style: Theme.of(context).textTheme.bodyMedium,
                            wrap: true,
                          ),
                          IconLabel(icon: Icons.edit, text: " Published · ${work.publishedDate}", size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          Visibility(
                            visible: work.statusLabel.isNotEmpty,
                            child: IconLabel(icon: Icons.check_rounded, text: "${work.statusLabel} · ${work.statusDate}", size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          IconLabel(icon: Icons.language, text: work.language, size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(icon: Icons.abc, text: "${work.words}", size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(icon: Icons.bookmarks, text: "${work.bookmarks}", size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(icon: Icons.favorite, text: "${work.kudos}", size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(icon: Icons.comment, text: "${work.comments}", size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          IconLabel(icon: Icons.remove_red_eye, text: "${work.hits}", size: 18.0, style: Theme.of(context).textTheme.bodyMedium),
                          Visibility(
                            visible: work.relationships.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15.0,),
                                const Text("Relationships:"),
                                Wrap(
                                  spacing: 4.0,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  children: [
                                    for (var relation in work.relationships) Chip(
                                      label: Text(relation),
                                      labelStyle: Theme.of(context).textTheme.labelSmall,
                                      labelPadding: const EdgeInsets.all(0),
                                      visualDensity: VisualDensity.compact,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ),
                          Visibility(
                            visible: work.characters.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15.0,),
                                const Text("Characters:"),
                                Wrap(
                                  spacing: 4.0,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  children: [
                                    for (var character in work.characters) Chip(
                                      label: Text(character),
                                      labelStyle: Theme.of(context).textTheme.labelSmall,
                                      labelPadding: const EdgeInsets.all(0),
                                      visualDensity: VisualDensity.compact,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ),
                          Visibility(
                            visible: work.addTags.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15.0,),
                                const Text("Tags:"),
                                Wrap(
                                  spacing: 4.0,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  children: [
                                    for (var tag in work.addTags) Chip(
                                      label: Text(tag),
                                      labelStyle: Theme.of(context).textTheme.labelSmall,
                                      labelPadding: const EdgeInsets.all(0),
                                      visualDensity: VisualDensity.compact,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                    ExpandableButton(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.keyboard_arrow_up, size: 26,)],),
                      ),
                    )
                  ],
                ),
            )
          ],
        )
    );
  }
}


