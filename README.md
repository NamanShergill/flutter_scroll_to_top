# flutter_scroll_to_top

A wrapper to show a scroll to top prompt to the user on ScrollView widgets.

## Installing

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_scroll_to_top: ^2.1.0
```
      
Import the package
```dart
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
```
      
## ScrollWrapper

Just wrap the scrollable widget you want to show the scroll to top prompt over with a `ScrollWrapper`.

```dart
ScrollWrapper(
    builder: (context, properties) => ListView.builder(
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
<a href="https://github.com/NamanShergill/flutter_scroll_to_top/blob/main/example/lib/pages/basic_prompt.dart"><img src="https://user-images.githubusercontent.com/33877135/115117228-2564dd00-9fbb-11eb-8f83-4feacf2560d1.gif" width="300" ></a>

## ScrollView Properties

If the child ScrollView has different properties for `scrollController`, `scrollDirection`, 
`primary` or `reverse` parameters than the default values, you need to pass them to the `ScrollWrapper`
widget as it requires the same parameters. It provides a `ScrollViewProperties` object in the `builder` 
callback that you can use to access the properties in the ScrollView widget.

```dart
ScrollWrapper(
    primary: true,
    scrollDirection: Axis.horizontal,
    reverse: true,
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
)
```

## Customisation

You can pass the following parameters to customise the prompt accordingly
- `enabledAtOffset` - At what scroll offset to enable the prompt on.
- `alwaysVisibleAtOffset` - If the prompt is to be always visible at the provided offset. Setting this to false only shows the prompt when the user starts scrolling upwards. Default value is false.
- `scrollOffsetUntilVisible` - Offset should the user scroll in the opposite direction before the prompt becomes visible.
- `scrollOffsetUntilHide` - Offset should the user scroll before the prompt hides itself, if visible.
- `promptAlignment` - Where on the widget to align the prompt.
- `promptDuration` - Duration it takes for the prompt to come into view/vanish.
- `promptAnimationCurve` - Animation Curve that the prompt will follow when coming into view.
- `promptAnimationType` - `PromptAnimation` that the prompt follows when animating. Has three options, `fade`, `scale` and `size`.
- `scrollToTopDuration` -  Duration it takes for the page to scroll to the top on prompt button press.
- `scrollToTopCurve` - Animation Curve for scrolling to the top.
- `promptTheme` - You can pass `PromptButtonTheme` to modify the prompt button further. It has the following parameters:
    - `padding` - Padding around the prompt button.
    - `iconPadding` - Padding around the icon inside the button.
    - `icon` - The icon inside the button.
    - `color` - Color of the prompt button.
    - `elevation` - Elevation of the button.

```dart
ScrollWrapper(
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
)
```
<a href="https://github.com/NamanShergill/flutter_scroll_to_top/blob/main/example/lib/pages/themed_prompt.dart"><img src="https://user-images.githubusercontent.com/33877135/115117233-2ac22780-9fbb-11eb-876e-171103e9ef91.gif" width="300" ></a>

## Custom Prompt Widget

You can replace the default prompt widget with a widget of your choosing by passing it off in the `promptReplacementBuilder` parameter.

```dart
ScrollWrapper(
    promptReplacementBuilder: (context, function) => MaterialButton(
        onPressed: () => function(),
        child: const Text('Scroll to top'),
    ),
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
)
```
<a href="https://github.com/NamanShergill/flutter_scroll_to_top/blob/main/example/lib/pages/basic_prompt.dart"><img src="https://user-images.githubusercontent.com/33877135/115117236-2e55ae80-9fbb-11eb-95c8-c8467797a877.gif" width="300" ></a>

## NestedScrollView Implementation

The implementation is similar, just wrap your scrollable body with the `ScrollWrapper`.
However, ***DO NOT*** pass a `scrollController` to the `ScrollWrapper` in this case, similar to how
you are not supposed to pass it to a ScrollView under a NestedScrollView.

[Check the example for code.](https://github.com/NamanShergill/flutter_scroll_to_top/blob/main/example/lib/pages/nested_scroll_view_example.dart)

<a href="https://github.com/NamanShergill/flutter_scroll_to_top/blob/main/example/lib/pages/nested_scroll_view_example.dart"><img src="https://user-images.githubusercontent.com/33877135/115117240-3281cc00-9fbb-11eb-8525-cbca1d64e902.gif" width="300" ></a>

