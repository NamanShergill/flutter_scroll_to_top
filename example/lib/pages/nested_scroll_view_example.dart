import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class NestedScrollViewExample extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: const SliverSafeArea(
                sliver: SliverAppBar(
                  expandedHeight: 300,
                  collapsedHeight: 100,
                  pinned: true,
                  title: Text('NestedScrollView Implementation'),
                ),
              ),
            )
          ],
          body: Builder(
            builder: (context) {
              NestedScrollView.sliverOverlapAbsorberHandleFor(context);
              return ScrollWrapper(
                promptReplacementBuilder: (context, function) => MaterialButton(
                  onPressed: function,
                  child: const Text('Scroll to top'),
                ),
                builder: (context, scrollController, scrollDirection) =>
                    CustomScrollView(
                  scrollDirection: scrollDirection,
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Tile $index'),
                          tileColor: Colors.grey.shade200,
                        ),
                      );
                    })),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
