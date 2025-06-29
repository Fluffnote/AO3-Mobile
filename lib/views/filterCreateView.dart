import 'package:ao3mobile/layout/ui/core/FilterDropdownMenu.dart';
import 'package:ao3mobile/layout/ui/core/FilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterCreateView extends StatelessWidget {
  const FilterCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();

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
            title: Text("INSERT FILTER NAME"),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () { },
              )
            ],
            backgroundColor: Theme.of(context).primaryColor,
            floating: true,
            pinned: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Theme.of(context).primaryColor
            ),
          ),
          FilterOptions()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {},
        child: Icon(Icons.save, size: 24,),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}



class FilterOptions extends StatelessWidget {
  const FilterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList( delegate: SliverChildListDelegate([
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          icon: Icons.filter_alt,
          hintText: "Filter Name"
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: const Divider()
      ),
      FilterTextField(
        margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
        icon: Icons.search,
        hintText: "Any Field"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.title,
          hintText: "Title"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.person,
          hintText: "Author/Artist"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.update,
          hintText: "How long ago?"
      ),
      FilterDropdownMenu(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.check,
          hintText: "Completion Status",
          initial: "",
          entries: [
            DropdownMenuEntry(value: "", label: "All works"),
            DropdownMenuEntry(value: "T", label: "Complete works only"),
            DropdownMenuEntry(value: "F", label: "Works in progress only")
          ],
      ),
      FilterDropdownMenu(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.swap_horiz,
          hintText: "Crossovers",
          initial: "",
          entries: [
            DropdownMenuEntry(value: "", label: "Include crossovers"),
            DropdownMenuEntry(value: "T", label: "Exclude crossovers"),
            DropdownMenuEntry(value: "F", label: "Only crossovers")
          ],
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: const Divider()
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.abc,
          hintText: "Word Count"
      ),
      FilterDropdownMenu(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.language,
          hintText: "Language"
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: const Divider()
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
          icon: Icons.grid_view,
          hintText: "Fandoms"
      ),
      FilterDropdownMenu(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.sensor_occupied,
          hintText: "Rating"
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: const Divider()
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: const Divider()
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.person_search,
          hintText: "Characters"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.people,
          hintText: "Relationships"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.tag,
          hintText: "Additional Tags"
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: const Divider()
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
          icon: Icons.remove_red_eye,
          hintText: "Hits"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.favorite,
          hintText: "Kudos"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.comment,
          hintText: "Comments"
      ),
      FilterTextField(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.bookmarks,
          hintText: "Bookmarks"
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: const Divider()
      ),
      FilterDropdownMenu(
          margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
          icon: Icons.sort_outlined,
          hintText: "Sort By",
          initial: "_score",
          entries: [
            DropdownMenuEntry(value: "_score", label: "Best Match"),
            DropdownMenuEntry(value: "authors_to_sort_on", label: "Author"),
            DropdownMenuEntry(value: "title_to_sort_on", label: "Title"),
            DropdownMenuEntry(value: "created_at", label: "Date Posted"),
            DropdownMenuEntry(value: "revised_at", label: "Date Updated"),
            DropdownMenuEntry(value: "word_count", label: "Word Count"),
            DropdownMenuEntry(value: "hits", label: "Hits"),
            DropdownMenuEntry(value: "kudos_count", label: "Kudos"),
            DropdownMenuEntry(value: "comments_count", label: "Comments"),
            DropdownMenuEntry(value: "bookmarks_count", label: "Bookmarks"),
          ],
      ),
      FilterDropdownMenu(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
          icon: Icons.sort_by_alpha,
          hintText: "Sort Direction",
          initial: "desc",
          entries: [
            DropdownMenuEntry(value: "asc", label: "Ascending"),
            DropdownMenuEntry(value: "desc", label: "Descending")
          ],
      ),
      SizedBox(height: 120,)
    ]));
  }
}

