import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ao3mobile/classes/miscUtils.dart';
import 'package:ao3mobile/pages/readingView.dart';

import '../classes/Work.dart';

class WorkView extends StatefulWidget {
  final int workId;
  const WorkView({super.key, required this.workId});

  @override
  State<WorkView> createState() => _WorkView();
}

class _WorkView extends State<WorkView> {
  late Future<Work> work;

  @override
  void initState() {
    super.initState();
    work = getWork(widget.workId);
  }

  @override
  void reassemble() {
    super.reassemble();
    work = getWork(widget.workId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: work,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () { Navigator.pop(context); },
              ),
              actions: [
                // IconButton(
                //   icon: const Icon(Icons.bookmark_add_outlined),
                //   onPressed: () {},
                // ),
                IconButton(
                  icon: const Icon(Icons.public),
                  onPressed: () {
                    openWebPage(snapshot.data!.id);
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.more_vert),
                //   onPressed: () {},
                // )
              ],
              backgroundColor: Theme.of(context).primaryColor,
              forceMaterialTransparency: true,
            ),
            body: MainWorkView(work: snapshot.data!,)
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
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          child: Text(work.title, style: Theme.of(context).textTheme.headlineLarge,),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
            child: WorkInfo(work: work)
        ),
        SingleChildScrollView(padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0), child: ExpandedMarkdownBox( body: work.firstSummary, ),),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          child: Text("${work.chapterStats} chapters", style: Theme.of(context).textTheme.bodyLarge,),
        ),
        for (var chapter in work.chapters) ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingView(work: work, chapterId: chapter.id)));
          },
          title: Text("${chapter.num}. ${chapter.title}"),
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          // trailing: Icon(Icons.download),
        )
      ],
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
                          Row(children: [
                            const Icon(Icons.person, size: 18.0,),
                            Text(" ${work.author}", style: Theme.of(context).textTheme.bodyMedium,)
                          ]),
                          Row(children: [
                            const Icon(Icons.sensor_occupied, size: 18.0,),
                            Text(" ${work.rating}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.warning, size: 18.0,),
                            Text(" ${work.archiveWarning}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.grid_view, size: 18.0,),
                            Text(" ${work.fandom}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.check_rounded, size: 18.0,),
                            Text(" ${work.statusLabel} · ${work.statusDate}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
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
                          Row(children: [
                            const Icon(Icons.person, size: 18.0,),
                            Text(" ${work.author}", style: Theme.of(context).textTheme.bodyMedium,)
                          ]),
                          Row(children: [
                            const Icon(Icons.sensor_occupied, size: 18.0,),
                            Text(" ${work.rating}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.warning, size: 18.0,),
                            Text(" ${work.archiveWarning}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.grid_view, size: 18.0,),
                            Text(" ${work.fandom}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.edit, size: 18.0,),
                            Text(" Published · ${work.publishedDate}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.check_rounded, size: 18.0,),
                            Text(" ${work.statusLabel} · ${work.statusDate}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.language, size: 18.0,),
                            Text(" ${work.language}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.abc, size: 18.0,),
                            Text(" ${work.words}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.bookmarks, size: 18.0,),
                            Text(" ${work.bookmarks}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.favorite, size: 18.0,),
                            Text(" ${work.kudos}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
                          Row(children: [
                            const Icon(Icons.comment, size: 18.0,),
                            Text(" ${work.comments}", style: Theme.of(context).textTheme.bodyMedium,),
                          ]),
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


