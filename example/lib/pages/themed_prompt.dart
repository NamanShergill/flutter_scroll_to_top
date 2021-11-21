import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class ThemedPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Themed Prompt'),
      ),
      body: ScrollWrapper(
        promptAlignment: Alignment.topCenter,
        promptAnimationCurve: Curves.elasticInOut,
        promptDuration: const Duration(milliseconds: 400),
        promptScrollOffset: 300,
        promptTheme: PromptButtonTheme(
            icon: const Icon(Icons.arrow_circle_up, color: Colors.amber),
            color: Colors.deepPurpleAccent,
            iconPadding: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(32)),
        builder: (scrollController, scrollDirection) => ListView.builder(
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
