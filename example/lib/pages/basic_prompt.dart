import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class BasicPrompt extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Prompt'),
      ),
      body: ScrollWrapper(
        scrollController: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Tile $index'),
              tileColor: Colors.grey.shade200,
            ),
          ),
        ),
      ),
    );
  }
}
