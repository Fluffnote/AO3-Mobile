import 'package:ao3mobile/layout/ui/core/IconLabel.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../data/models/Work.dart';
import '../../views/workView.dart';
import 'core/ExpandedMarkdownBox.dart';



class WorkCard extends StatelessWidget {
  final Work work;
  const WorkCard({super.key, required this.work});


  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkView(workId: work.id, refreshType: 1)));
          },
          child: ExpandableNotifier(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expandable(
                    collapsed: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(work.title, style: Theme.of(context).textTheme.titleMedium,),
                        Opacity(
                          opacity: 0.65,
                          child: Row(
                            children: [
                              Text(work.author, style: Theme.of(context).textTheme.labelSmall,),
                              const Spacer(),
                              IconLabel(icon: Icons.language, text: work.language)
                            ],
                          )
                        ),
                        Visibility(
                          visible: work.addTags.isNotEmpty,
                          child: Opacity(
                            opacity: 0.65,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 26,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (var tag in work.addTags) Chip(
                                    label: Text(tag),
                                    labelStyle: Theme.of(context).textTheme.labelSmall,
                                    labelPadding: const EdgeInsets.all(0),
                                    visualDensity: VisualDensity.compact,
                                  )
                                ],
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Visibility(visible: work.summary.isNotEmpty, child: ExpandedMarkdownBox(body: work.summary, showButton: false)),
                        ExpandableButton(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.keyboard_arrow_down, size: 26,)],),
                          ),
                        ),
                        Opacity(
                          opacity: 0.65,
                          child: Row(
                            children: [
                              Visibility(
                                  visible: work.chapterStats.isNotEmpty,
                                  child: IconLabel(icon: Icons.menu_book, text: work.chapterStats)
                              ),
                              IconLabel(icon: Icons.abc, text: "${work.words}", size: 26.0, margin: const EdgeInsets.only(left: 5.0)),
                              IconLabel(icon: Icons.favorite, text: "${work.kudos}", margin: const EdgeInsets.only(left: 5.0)),
                              IconLabel(icon: Icons.comment, text: "${work.comments}", margin: const EdgeInsets.only(left: 5.0)),
                              const Spacer(),
                              Text(work.statusDate, style: Theme.of(context).textTheme.labelSmall,),
                            ],
                          ),
                        )
                      ],
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(work.title, style: Theme.of(context).textTheme.titleMedium,),
                        Opacity(
                            opacity: 0.65,
                            child: Row(
                              children: [
                                Text(work.author, style: Theme.of(context).textTheme.labelSmall,),
                                const Spacer(),
                                Row(children: [
                                  const Icon(Icons.language, size: 14.0,),
                                  Text(" ${work.language}", style: Theme.of(context).textTheme.labelSmall,),
                                ]),
                              ],
                            )
                        ),
                        Visibility(
                          visible: work.addTags.isNotEmpty,
                          child: Opacity(
                              opacity: 0.65,
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Wrap(
                                  spacing: 4.0,
                                  runSpacing: 0,
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
                              )
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Visibility(visible: work.summary.isNotEmpty, child: ExpandedMarkdownBox(body: work.summary, showButton: false, stayOpen: true)),
                        ExpandableButton(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.keyboard_arrow_up, size: 26,)],),
                          ),
                        ),
                        Opacity(
                          opacity: 0.65,
                          child: Row(
                            children: [
                              Visibility(
                                  visible: work.chapterStats.isNotEmpty,
                                  child: IconLabel(icon: Icons.menu_book, text: work.chapterStats)
                              ),
                              IconLabel(icon: Icons.abc, text: "${work.words}", size: 26.0, margin: const EdgeInsets.only(left: 5.0)),
                              IconLabel(icon: Icons.favorite, text: "${work.kudos}", margin: const EdgeInsets.only(left: 5.0)),
                              IconLabel(icon: Icons.comment, text: "${work.comments}", margin: const EdgeInsets.only(left: 5.0)),
                              const Spacer(),
                              Text(work.statusDate, style: Theme.of(context).textTheme.labelSmall,),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        )
    );
  }
}
