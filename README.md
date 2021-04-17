# flutter_scroll_to_top

A wrapper to show a scroll to top prompt to the user on scrollable widgets.

## Installing

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_scroll_to_top: ^1.0.0
```
      
Import the package
```dart
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
```
      
## ScrollWrapper

Just wrap the scrollable widget you want to show the scroll to top prompt over with a `ScrollWrapper`, and supply the `ScrollController` of the scrollable widget to the wrapper.

```dart
ScrollWrapper(
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
```
![basic_prompt](https://user-images.githubusercontent.com/33877135/115117228-2564dd00-9fbb-11eb-8f83-4feacf2560d1.gif | width=250)


## Customisation

You can pass the following parameters to customise the prompt accordingly
- `promptScrollOffset` - At what scroll offset to show the prompt on.
- `promptAlignment` - Where on the widget to align the prompt.
- `promptDuration` - Duration it takes for the prompt to come into view/vanish.
- `promptAnimationCurve` - Animation Curve that the prompt will follow when coming into view.
- `promptTheme` - You can pass `PromptButtonTheme` to modify the prompt button further. It has the following parameters:
    - `padding` - Padding around the prompt button.
    - `iconPadding` - adding around the icon inside the button.
    - `icon` - The icon inside the button.
    - `color` - Color of the prompt button.

```dart
ScrollWrapper(
        scrollController: scrollController,
        promptAlignment: Alignment.topCenter,
        promptAnimationCurve: Curves.elasticInOut,
        promptDuration: Duration(milliseconds: 400),
        promptScrollOffset: 300,
        promptTheme: PromptButtonTheme(
            icon: Icon(Icons.arrow_circle_up, color: Colors.amber),
            color: Colors.deepPurpleAccent,
            iconPadding: EdgeInsets.all(16),
            padding: EdgeInsets.all(32)),
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
```
![themed_prompt](https://user-images.githubusercontent.com/33877135/115117233-2ac22780-9fbb-11eb-876e-171103e9ef91.gif | width=250))


## Custom Prompt Widget

You can replace the default prompt widget with a widget of your choosing by passing it off in the `promptReplacementBuilder` parameter.

```dart
ScrollWrapper(
        scrollController: scrollController,
        promptReplacementBuilder: (BuildContext context, Function scrollToTop) {
          return MaterialButton(
            onPressed: () {
              scrollToTop();
            },
            child: Text('Scroll to top'),
          );
        },
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
      )
```
![custom_prompt](https://user-images.githubusercontent.com/33877135/115117236-2e55ae80-9fbb-11eb-95c8-c8467797a877.gif | width=250)


## NestsedScrollView Implimentation

The implimentation is similar, just wrap your scrollable body with the `ScrollWrapper` and pass off the controller of the parent `NestsedScrollView` to the wrapper.

[Check the example for code.](https://github.com/NamanShergill/flutter_scroll_to_top/blob/main/example/lib/pages/nested_scroll_view_example.dart)

![nested_scroll_view](https://user-images.githubusercontent.com/33877135/115117240-3281cc00-9fbb-11eb-8525-cbca1d64e902.gif | width=250)

