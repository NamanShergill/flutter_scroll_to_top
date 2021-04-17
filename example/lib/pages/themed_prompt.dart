import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class ThemedPrompt extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Themed Prompt'),
      ),
      body: ScrollWrapper(
        scrollController: scrollController,
        promptAlignment: Alignment.topCenter,
        promptAnimationCurve: Curves.elasticInOut,
        promptDuration: Duration(milliseconds: 400),
        promptScrollOffset: 300,
        promptTheme: PromptButtonTheme(
            promptIcon: Icon(Icons.arrow_circle_up, color: Colors.amber),
            promptColor: Colors.deepPurpleAccent,
            promptIconPadding: EdgeInsets.all(16),
            promptPadding: EdgeInsets.all(32)),
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
