import 'package:ao3mobile/layout/ui/core/AO3Symbols.dart';
import 'package:ao3mobile/layout/ui/core/IconLabel.dart';
import 'package:expandable/expandable.dart';
import 'package:exui/exui.dart';
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkView(workId: work.id, refreshType: 2)));
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
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(color: Colors.white, height: 25, width: 25),
                            AO3Symbols(
                              height: 40, width: 40,
                              ratingSymbol: work.ratingSymbol,
                              RPOSymbol: work.RPOSymbol,
                              warningSymbol: work.warningSymbol,
                              statusSymbol: work.statusSymbol
                            ),
                            Text(work.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis)
                                .marginOnly(left: 10).flexTight(1)
                          ],
                        ),
                        Row(
                          children: [
                            Text(work.author, style: Theme.of(context).textTheme.labelSmall,),
                            const Spacer(),
                            IconLabel(icon: Icons.language, text: work.language)
                          ],
                        ).opacity(0.65).marginTop(10),
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
                        ExpandedMarkdownBox(body: work.summary, showButton: false).visibleIf(work.summary.isNotEmpty),
                        ExpandableButton(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.keyboard_arrow_down, size: 26,)],),
                          ),
                        ),
                        Row(
                          children: [
                            Visibility(
                                visible: work.chapterStats.isNotEmpty,
                                child: IconLabel(icon: Icons.menu_book, text: work.chapterStats)
                            ),
                            IconLabel(icon: Icons.abc, text: "${work.words}", size: 26.0, margin: const EdgeInsets.only(left: 5.0)),
                            IconLabel(icon: Icons.favorite, text: "${work.kudos}", margin: const EdgeInsets.only(left: 5.0)),
                            IconLabel(icon: Icons.remove_red_eye, text: "${work.hits}", margin: const EdgeInsets.only(left: 5.0)),
                            const Spacer(),
                            Text(work.statusDate, style: Theme.of(context).textTheme.labelSmall,),
                          ],
                        ).opacity(0.65),
                      ],
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(color: Colors.white, height: 25, width: 25),
                            AO3Symbols(
                                height: 40, width: 40,
                                ratingSymbol: work.ratingSymbol,
                                RPOSymbol: work.RPOSymbol,
                                warningSymbol: work.warningSymbol,
                                statusSymbol: work.statusSymbol
                            ),
                            Text(work.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis)
                                .marginOnly(left: 10).flexTight(1)
                          ],
                        ),
                        Row(
                          children: [
                            Text(work.author, style: Theme.of(context).textTheme.labelSmall,),
                            const Spacer(),
                            IconLabel(icon: Icons.language, text: work.language)
                          ],
                        ).opacity(0.65).marginTop(10),
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
                        ExpandedMarkdownBox(body: work.summary, showButton: false, stayOpen: true).visibleIf(work.summary.isNotEmpty),
                        ExpandableButton(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.keyboard_arrow_up, size: 26,)],),
                          ),
                        ),
                        Row(
                          children: [
                            Visibility(
                                visible: work.chapterStats.isNotEmpty,
                                child: IconLabel(icon: Icons.menu_book, text: work.chapterStats)
                            ),
                            IconLabel(icon: Icons.abc, text: "${work.words}", size: 26.0, margin: const EdgeInsets.only(left: 5.0)),
                            IconLabel(icon: Icons.favorite, text: "${work.kudos}", margin: const EdgeInsets.only(left: 5.0)),
                            IconLabel(icon: Icons.remove_red_eye, text: "${work.hits}", margin: const EdgeInsets.only(left: 5.0)),
                            const Spacer(),
                            Text(work.statusDate, style: Theme.of(context).textTheme.labelSmall,),
                          ],
                        ).opacity(0.65),
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
