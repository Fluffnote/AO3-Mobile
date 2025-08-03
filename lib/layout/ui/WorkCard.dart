import 'package:ao3mobile/layout/ui/core/AO3Symbols.dart';
import 'package:ao3mobile/layout/ui/core/IconLabel.dart';
import 'package:expandable/expandable.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';

import '../../data/models/Work.dart';
import '../../views/workView.dart';
import 'core/ExpandedMarkdownBox.dart';



class WorkCard extends StatefulWidget {
  final Work work;
  const WorkCard({super.key, required this.work});

  @override
  State<WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard> {
  bool expanded = false;

  @override
  void didUpdateWidget(covariant WorkCard oldWidget) {
    expanded = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkView(workId: widget.work.id, refreshType: 2)));
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                (expanded) ? _WorkCardFullView(work: widget.work) : _WorkCardMinView(work: widget.work),
                InkWell(
                    onTap: (){ setState(() { expanded = !expanded; });},
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(!expanded?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up, size: 26,)],),
                    )
                ),
                _StatsRow(
                    chapterStats: widget.work.chapterStats,
                    words: widget.work.words,
                    kudos: widget.work.kudos,
                    hits: widget.work.hits,
                    statusDate: widget.work.statusDate
                ),
              ],
            ),
          )
        )
    );
  }
}



class _WorkCardMinView extends StatelessWidget {
  final Work work;
  const _WorkCardMinView({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
        Text(work.summary, maxLines: 3, overflow: TextOverflow.ellipsis,).visibleIf(work.summary.isNotEmpty),
      ],
    );
  }
}



class _WorkCardFullView extends StatelessWidget {
  final Work work;
  const _WorkCardFullView({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
        Text(work.summary,).visibleIf(work.summary.isNotEmpty),
      ],
    );
  }
}



class _StatsRow extends StatelessWidget {
  final String chapterStats;
  final int words;
  final int kudos;
  final int hits;
  final String statusDate;

  const _StatsRow({
    super.key,
    required this.chapterStats,
    required this.words,
    required this.kudos,
    required this.hits,
    required this.statusDate
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconLabel(icon: Icons.menu_book, text: chapterStats).visibleIf(chapterStats.isNotEmpty),
        IconLabel(icon: Icons.abc, text: "$words", size: 26.0, margin: const EdgeInsets.only(left: 5.0)),
        IconLabel(icon: Icons.favorite, text: "$kudos", margin: const EdgeInsets.only(left: 5.0)),
        IconLabel(icon: Icons.remove_red_eye, text: "$hits", margin: const EdgeInsets.only(left: 5.0)),
        const Spacer(),
        Text(statusDate, style: Theme.of(context).textTheme.labelSmall,),
      ],
    ).opacity(0.65);
  }
}

