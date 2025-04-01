import 'dart:ffi';

import 'package:ao3mobile/data/models/Work.dart';
import 'package:ao3mobile/data/repositories/SearchRepo.dart';
import 'package:ao3mobile/layout/ui/core/IconLabel.dart';
import 'package:ao3mobile/views/workView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/models/SearchData.dart';
import '../data/models/SearchQueryParameters.dart';
import '../layout/ui/MiscUtils.dart';
import '../layout/ui/WorkCard.dart';

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
    final SearchRepo searchRepo = new SearchRepo();

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
                works = searchRepo.workSearch(SearchQueryParameters(query: value));
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
                    works = searchRepo.workSearch(SearchQueryParameters(query: ""));
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
          snap: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
          )
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
          for (int i = 0; i<searchData.works.length; i++) WorkCard(work: searchData.works[i])
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
                child: const IconLabel(
                  icon: Icons.open_in_new,
                  size: 15.0,
                  text: "All News",
                  padding: EdgeInsets.all(5),
                  right: true,
                ),
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
            child: IconLabel(
              icon: Icons.open_in_new,
              size: 15.0,
              text: "OTW News Outlets",
              style: Theme.of(context).textTheme.bodyMedium,
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5)
            ),
          )
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          child: InkWell(
            onTap: (){ openWebPage("https://twitter.com/AO3_Status"); },
            child: IconLabel(
              icon: FontAwesomeIcons.twitter,
              size: 15.0,
              text: "@AO3_Status on Twitter",
              style: Theme.of(context).textTheme.bodyMedium,
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5)
            ),
          )
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 0, 15),
          child: InkWell(
            onTap: (){ openWebPage("https://ao3org.tumblr.com/"); },
            child: IconLabel(
              icon: FontAwesomeIcons.tumblr,
              size: 15.0,
              text: "ao3org on Tumblr",
              style: Theme.of(context).textTheme.bodyMedium,
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5)
            )
          )
        ),
      ])
    );
  }
}



