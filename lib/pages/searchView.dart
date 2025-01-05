import 'package:ao3mobile/classes/Work.dart';
import 'package:ao3mobile/pages/workView.dart';
import 'package:flutter/material.dart';

import '../classes/Search.dart';
import '../classes/miscUtils.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  late TextEditingController searchCon;
  late Future<SearchData> works;
  String query = "";

  @override
  void initState() {
    super.initState();

    searchCon = TextEditingController();
    works = workSearch(WorkSearchQueryParameters(query: ""));
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //
  //   searchCon = TextEditingController();
  //   works = workSearch(WorkSearchQueryParameters(query: ""));
  // }

  @override
  void dispose() {
    searchCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final _scrollController = ScrollController();
    // return Scaffold(
    //   body: CustomScrollView(
    //     controller: _scrollController,
    //     scrollBehavior: const MaterialScrollBehavior(),
    //     slivers: [
    //       SliverAppBar(
    //         title: TextField(
    //           textInputAction: TextInputAction.search,
    //           controller: searchCon,
    //           onSubmitted: (String value) {
    //             setState(() {
    //               query = value;
    //               works = null;
    //               works = workSearch(WorkSearchQueryParameters(query: value));
    //             });
    //           },
    //           decoration: const InputDecoration(
    //             border: InputBorder.none,
    //             hintText: 'Search...',
    //             icon: Icon(Icons.search),
    //           ),
    //         ),
    //         actions: [
    //           Visibility(
    //             visible: query.isNotEmpty,
    //             child: IconButton(
    //               onPressed: () {
    //                 searchCon.clear();
    //                 setState(() {
    //                   query = "";
    //                   works = workSearch(WorkSearchQueryParameters(query: ""));
    //                 });
    //               },
    //               icon: const Icon(Icons.clear),
    //             ),
    //           ),
    //           IconButton(
    //             icon: const Icon(Icons.filter_list_outlined),
    //             onPressed: () {},
    //           ),
    //         ],
    //         // backgroundColor: Theme.of(context).primaryColor,
    //         floating: true,
    //         pinned: false,
    //         // forceMaterialTransparency: true,
    //       ),
    //       SliverList(
    //           delegate: SliverChildListDelegate([
    //             for (int i = 0; i < 100; i++)
    //               ListTile(
    //                 leading: CircleAvatar(),
    //                 title: Text(i.toString()),
    //               )
    //           ])
    //       )
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
        title: TextField(
          textInputAction: TextInputAction.search,
          controller: searchCon,
          onSubmitted: (String value) {
            setState(() {
              query = value;
              works = workSearch(WorkSearchQueryParameters(query: value));
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search...',
            icon: Icon(Icons.search),
          ),
        ),
        actions: [
          Visibility(
            visible: query.isNotEmpty,
            child: IconButton(
              onPressed: () {
                searchCon.clear();
                setState(() {
                  query = "";
                  works = workSearch(WorkSearchQueryParameters(query: ""));
                });
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {},
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        forceMaterialTransparency: true,
      ),
      body: FutureBuilder(
        future: works,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PartialWorkList(searchData: snapshot.requireData);
          } else if (snapshot.hasError) {
            return FutureErrorBody(snapshot: snapshot);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PartialWorkList extends StatelessWidget {
  final SearchData searchData;
  const PartialWorkList({super.key, required this.searchData});

  @override
  Widget build(BuildContext context) {
    if (searchData.works.isNotEmpty) {
      return ListView(
        children: [
          Visibility(
            visible: searchData.numFound.isNotEmpty,
            child: Opacity(
              opacity: 0.65,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: Text(searchData.numFound),
              ),
            )
          ),
          for (int i = 0; i<searchData.works.length; i++) PartialWorkCard(partWork: searchData.works[i])
        ],
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(40.0),
        child: Text("Nothing to see here :/", style: Theme.of(context).textTheme.displaySmall,),
      ),
    );
  }
}

class PartialWorkCard extends StatelessWidget {
  final PartialWork partWork;
  const PartialWorkCard({super.key, required this.partWork});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkView(workId: partWork.id)));
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(partWork.title, style: Theme.of(context).textTheme.titleMedium,),
              Opacity(
                  opacity: 0.65,
                  child: Row(
                    children: [
                      Text(partWork.author, style: Theme.of(context).textTheme.labelSmall,),
                      const Spacer(),
                      Row(children: [
                        const Icon(Icons.language, size: 14.0,),
                        Text(" ${partWork.language}", style: Theme.of(context).textTheme.labelSmall,),
                      ]),
                    ],
                  )
              ),
              Visibility(
                visible: partWork.tags.isNotEmpty,
                child: Opacity(
                    opacity: 0.65,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 26,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var tag in partWork.tags) Chip(
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
              Visibility(visible: partWork.summary.isNotEmpty, child: ExpandedMarkdownBox(body: partWork.summary,)),
              Opacity(
                opacity: 0.65,
                child: Row(
                  children: [
                    Visibility(
                        visible: partWork.chapters.isNotEmpty,
                        child: Row(children: [
                          const Icon(Icons.menu_book, size: 14.0,),
                          Text(" ${partWork.chapters}", style: Theme.of(context).textTheme.labelSmall,),
                        ])
                    ),
                    Visibility(
                        visible: partWork.words.isNotEmpty,
                        child: Row(children: [
                          const SizedBox(width: 5.0,),
                          const Icon(Icons.abc, size: 26.0,),
                          Text(" ${partWork.words}", style: Theme.of(context).textTheme.labelSmall,),
                        ])
                    ),
                    Visibility(
                      visible: partWork.kudos.isNotEmpty,
                      child: Row(children: [
                        const SizedBox(width: 5.0,),
                        const Icon(Icons.favorite, size: 14.0,),
                        Text(" ${partWork.kudos}", style: Theme.of(context).textTheme.labelSmall,),
                      ]),
                    ),
                    Visibility(
                      visible: partWork.comments.isNotEmpty,
                      child: Row(children: [
                        const SizedBox(width: 5.0,),
                        const Icon(Icons.comment, size: 14.0,),
                        Text(" ${partWork.comments}", style: Theme.of(context).textTheme.labelSmall,),
                      ]),
                    ),
                    const Spacer(),
                    Text(partWork.lastEditDate, style: Theme.of(context).textTheme.labelSmall,),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}


