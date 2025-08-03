import 'dart:math';

import 'package:ao3mobile/data/repositories/WorkRepo.dart';
import 'package:ao3mobile/views/readingView.dart';
import 'package:ao3mobile/views/workView.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/History.dart';
import '../layout/ui/MiscUtils.dart';

class Historyview extends StatefulWidget {
  const Historyview({super.key});

  @override
  State<Historyview> createState() => _HistoryviewState();
}

class _HistoryviewState extends State<Historyview> {
  late TextEditingController searchCon;
  late Future<List<History>> historyEntries;
  final WorkRepo workRepo = new WorkRepo();
  String query = "";
  bool showSearch = false;

  void updateList() {
    historyEntries = workRepo.getHistoryList();
  }

  @override
  void initState() {
    super.initState();

    searchCon = TextEditingController();
    updateList();
  }

  @override
  void dispose() {
    searchCon.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    return CustomScrollView(
      controller: _scrollController,
      scrollBehavior: const MaterialScrollBehavior(),
      slivers: [
        SliverAppBar(
          title: Text("History"),
          actions: [
            // IconButton(
            //   onPressed: () {
            //     setState(() {
            //       showSearch = true;
            //     });
            //   },
            //   icon: const Icon(Icons.search),
            // ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {},
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
          floating: true,
          pinned: false,
          // forceMaterialTransparency: true,
        ),
        SliverList(delegate: SliverChildListDelegate([
          FutureBuilder(
            future: historyEntries,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.requireData.isNotEmpty) return HistoryList(historyEntries: snapshot.requireData);
                else return Container();
              } else if (snapshot.hasError) {
                return FutureErrorBody(snapshot: snapshot);
              }
              return Container(
                margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                child: const Center(child: CircularProgressIndicator())
              );
            },
          )
        ]))
      ],
    );
  }
}

class HistoryList extends StatefulWidget {
  final List<History> historyEntries;
  const HistoryList({super.key, required this.historyEntries});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final WorkRepo workRepo = new WorkRepo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        for (History history in widget.historyEntries)
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Card(
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingView(workId: history.workId, chapterId: history.chapId)));
              },
              title: Text(history.workName).onTap(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WorkView(workId: history.workId)));
              }),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(history.author),
                  Text("${history.chapNum}. ${history.chapName} - ${(min((history.pos/(max(history.maxPos, 1)*0.98))*100, 100)).round()}%"),
                  Text("${DateFormat.yMMMd().format(history.accessDate)} - ${DateFormat.jm().format(history.accessDate)}")
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  workRepo.deleteHistory(history.workId);
                  
                  setState(() {});
                },
                icon: const Icon(Icons.delete)),
            ),
          )
        )
      ]
    );
  }
}

