import 'package:flutter/material.dart';

class Libraryview extends StatefulWidget {
  const Libraryview({super.key});

  @override
  State<Libraryview> createState() => _LibraryviewState();
}

class _LibraryviewState extends State<Libraryview> {
  late TextEditingController searchCon;
  String query = "";

  @override
  void initState() {
    super.initState();

    searchCon = TextEditingController();
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
          title: Text("Library"),
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
              icon: const Icon(Icons.sort),
              onPressed: () {},
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
          floating: true,
          pinned: false,
          // forceMaterialTransparency: true,
        ),
        SliverList(delegate: SliverChildListDelegate([
          // FutureBuilder(
          //   future: historyEntries,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       if (snapshot.requireData.isNotEmpty) return HistoryList(historyEntries: snapshot.requireData);
          //       else return Container();
          //     } else if (snapshot.hasError) {
          //       return FutureErrorBody(snapshot: snapshot);
          //     }
          //     return Container(
          //         margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
          //         child: const Center(child: CircularProgressIndicator())
          //     );
          //   },
          // )
        ]))
      ],
    );
  }
}

class LibraryList extends StatefulWidget {
  const LibraryList({super.key});

  @override
  State<LibraryList> createState() => _LibraryListState();
}

class _LibraryListState extends State<LibraryList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 15.0),
          // for (History history in widget.historyEntries)
          //   Container(
          //       margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          //       child: Card(
          //         child: ListTile(
          //           onTap: () {
          //             Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingView(workId: history.workId, chapterId: history.chapId)));
          //           },
          //           title: Text(history.workName),
          //           subtitle: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(history.author),
          //               Text("${history.chapNum}. ${history.chapName} - ${(min((history.pos/(history.maxPos*0.98))*100, 100)).round()}%"),
          //               Text("${DateFormat.yMMMd().format(history.accessDate)} - ${DateFormat.jm().format(history.accessDate)}")
          //             ],
          //           ),
          //           trailing: IconButton(
          //               onPressed: () {
          //                 deleteHistory(history.workId);
          //                 setState(() {});
          //               },
          //               icon: const Icon(Icons.delete)),
          //         ),
          //       )
          //   )
        ]
    );
  }
}

