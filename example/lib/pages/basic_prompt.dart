import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class BasicPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Prompt'),
      ),
      body: ScrollWrapper(
        builder: (scrollController, scrollDirection) => ListView.builder(
          controller: scrollController,
          scrollDirection: scrollDirection,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 50,
              child: ListTile(
                title: Text('Tile $index'),
                tileColor: Colors.grey.shade200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
