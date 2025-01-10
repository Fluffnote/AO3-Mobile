import 'dart:ffi';

import 'package:ao3mobile/classes/Work.dart';
import 'package:ao3mobile/pages/workView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../classes/Search.dart';
import '../classes/MiscUtils.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  late TextEditingController searchCon;
  late var works;
  String query = "";
  bool initScreen = true;

  @override
  void initState() {
    super.initState();

    searchCon = TextEditingController();
    works = null;
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
    final _scrollController = ScrollController();
    return CustomScrollView(
      controller: _scrollController,
      scrollBehavior: const MaterialScrollBehavior(),
      slivers: [
        SliverAppBar(
          title: TextField(
            textInputAction: TextInputAction.search,
            controller: searchCon,
            onSubmitted: (String value) {
              setState(() {
                query = value;
                initScreen = false;
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
          floating: true,
          pinned: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).primaryColor
          ),
          // forceMaterialTransparency: true,
        ),
        FutureBuilder(
          future: works,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PartialWorkList(searchData: snapshot.requireData as SearchData);
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(child: FutureErrorBody(snapshot: snapshot));
            } else if (initScreen) {
              return DefaultPane();
            }
            return SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                child: Center(child: CircularProgressIndicator())
              )
            );
          },
        )
      ],
    );
  }
}

class PartialWorkList extends StatelessWidget {
  final SearchData searchData;
  const PartialWorkList({super.key, required this.searchData});

  @override
  Widget build(BuildContext context) {
    if (searchData.works.isNotEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate([
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
          for (int i = 0; i<searchData.works.length; i++) PartialWorkCard(work: searchData.works[i])
        ]),
      );
    }

    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: Text("Nothing to see here :/", style: Theme.of(context).textTheme.displaySmall,),
        ),
      ),
    );
  }
}

class PartialWorkCard extends StatelessWidget {
  final Work work;
  const PartialWorkCard({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkView(workId: work.id, refreshType: 1)));
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
              Visibility(visible: work.summary.isNotEmpty, child: ExpandedMarkdownBox(body: work.summary,)),
              Opacity(
                opacity: 0.65,
                child: Row(
                  children: [
                    Visibility(
                        visible: work.chapterStats.isNotEmpty,
                        child: Row(children: [
                          const Icon(Icons.menu_book, size: 14.0,),
                          Text(" ${work.chapterStats}", style: Theme.of(context).textTheme.labelSmall,),
                        ])
                    ),
                    Row(children: [
                      const SizedBox(width: 5.0,),
                      const Icon(Icons.abc, size: 26.0,),
                      Text(" ${work.words}", style: Theme.of(context).textTheme.labelSmall,),
                    ]),
                    Row(children: [
                      const SizedBox(width: 5.0,),
                      const Icon(Icons.favorite, size: 14.0,),
                      Text(" ${work.kudos}", style: Theme.of(context).textTheme.labelSmall,),
                    ]),
                    Row(children: [
                      const SizedBox(width: 5.0,),
                      const Icon(Icons.comment, size: 14.0,),
                      Text(" ${work.comments}", style: Theme.of(context).textTheme.labelSmall,),
                    ]),
                    const Spacer(),
                    Text(work.statusDate, style: Theme.of(context).textTheme.labelSmall,),
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

class DefaultPane extends StatelessWidget {
  const DefaultPane({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 30),
          child: Text(
              "The Archive of Our Own is a project of the Organization for Transformative Works.",
              style: Theme.of(context).textTheme.titleLarge
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Text(
              "A fan-created, fan-run, nonprofit, noncommercial archive for transformative fanworks, like fanfiction, fanart, fan videos, and podfic",
              style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Text(
              "This is an unofficial app dedicated to the project",
              style: Theme.of(context).textTheme.titleMedium
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: const Divider(),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Row(
            children: [
              Text(
                  "AO3 News",
                  style: Theme.of(context).textTheme.titleLarge
              ),
              const Spacer(),
              InkWell(
                onTap: (){ openWebPage("https://archiveofourown.org/admin_posts"); },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: const Row(
                    children: [
                      Text("All News "),
                      Icon(Icons.open_in_new, size: 15.0,)
                    ]
                  )
                )
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: const Divider(),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Text(
              "Follow us",
              style: Theme.of(context).textTheme.titleLarge
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Text(
              "Follow the Archive on Twitter or Tumblr for status updates, and don't forget to check out the Organization for Transformative Works' news outlets for updates on our other projects!",
              style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          child: InkWell(
            onTap: (){ openWebPage("https://www.transformativeworks.org/where-find-us/"); },
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Row(
                children: [
                  Icon(Icons.open_in_new, size: 15.0,),
                  Text("  OTW News Outlets", style: Theme.of(context).textTheme.bodyMedium)
                ]
              )
            )
          )
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          child: InkWell(
              onTap: (){ openWebPage("https://twitter.com/AO3_Status"); },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  child: Row(
                      children: [
                        Icon(FontAwesomeIcons.twitter, size: 15.0,),
                        Text("  @AO3_Status on Twitter", style: Theme.of(context).textTheme.bodyMedium)
                      ]
                  )
              )
          )
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 0, 15),
          child: InkWell(
              onTap: (){ openWebPage("https://ao3org.tumblr.com/"); },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  child: Row(
                      children: [
                        Icon(FontAwesomeIcons.tumblr, size: 15.0,),
                        Text("  ao3org on Tumblr", style: Theme.of(context).textTheme.bodyMedium)
                      ]
                  )
              )
          )
        ),
      ])
    );
  }
}



