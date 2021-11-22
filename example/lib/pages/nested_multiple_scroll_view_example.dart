import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class NestedMultipleScrollViewExample extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  sliver: SliverAppBar(
                    expandedHeight: 300,
                    collapsedHeight: 100,
                    pinned: true,
                    title:
                        const Text('NestedMultipleScrollView Implementation'),
                    bottom: TabBar(
                        tabs: [1, 2, 3]
                            .map((e) => Tab(
                                  child: Text(e.toString()),
                                ))
                            .toList()),
                  ),
                ),
              )
            ],
            body: Builder(
              builder: (context) {
                NestedScrollView.sliverOverlapAbsorberHandleFor(context);
                return TabBarView(
                    children: List.generate(
                        3,
                        (index) => ScrollWrapper.nsvMultipleScrollViews(
                              nestedScrollViewController: scrollController,
                              promptReplacementBuilder: (context, function) =>
                                  MaterialButton(
                                onPressed: function,
                                child: const Text('Scroll to top'),
                              ),
                              builder: (context, properties) =>
                                  CustomScrollView(
                                controller: properties.scrollController,
                                scrollDirection: properties.scrollDirection,
                                reverse: properties.reverse,
                                primary: properties.primary,
                                slivers: [
                                  SliverOverlapInjector(
                                    handle: NestedScrollView
                                        .sliverOverlapAbsorberHandleFor(
                                            context),
                                  ),
                                  SliverList(delegate:
                                      SliverChildBuilderDelegate(
                                          (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Text('Tile $index'),
                                      ),
                                    );
                                  })),
                                ],
                              ),
                            )));
              },
            ),
          ),
        ),
      ),
    );
  }
}
