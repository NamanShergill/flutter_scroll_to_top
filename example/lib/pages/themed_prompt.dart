import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class ThemedPrompt extends StatelessWidget {
  const ThemedPrompt({Key? key}) : super(key: key);

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
        enabledAtOffset: 300,
        scrollOffsetUntilVisible: 500,
        promptTheme: const PromptButtonTheme(
            icon: Icon(Icons.arrow_circle_up, color: Colors.amber),
            color: Colors.deepPurpleAccent,
            iconPadding: EdgeInsets.all(16),
            padding: EdgeInsets.all(32)),
        builder: (context, properties) => ListView.builder(
          controller: properties.scrollController,
          scrollDirection: properties.scrollDirection,
          reverse: properties.reverse,
          primary: properties.primary,
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
