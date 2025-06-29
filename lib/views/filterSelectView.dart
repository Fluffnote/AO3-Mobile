import 'package:ao3mobile/views/filterCreateView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterSelectView extends StatelessWidget {
  const FilterSelectView({super.key});

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
            title: Text("Filters"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FilterCreateView()));
                },
              )
            ],
            backgroundColor: Theme.of(context).primaryColor,
            floating: true,
            pinned: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Theme.of(context).primaryColor
            ),
          ),
        ],
      ),
    );
  }
}
