import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/src/ui/expand_animation.dart';

typedef ReplacementBuilder = Widget Function(
    BuildContext context, Function function);

/// Wrap the widget to show a scroll to top prompt over when a certain scroll
/// offset is reached.
class ScrollWrapper extends StatefulWidget {
  /// [ScrollController] of the scrollable widget to scroll to the top of when
  /// the prompt is pressed.
  final ScrollController scrollController;

  /// The widget to show the prompt over when scroll is at an offset.
  final Widget child;

  /// At what scroll offset to show the prompt on.
  final double promptScrollOffset;

  /// **Replace the prompt button with your own custom widget. Returns the**
  /// **[BuildContext] and the [Function] to call to scroll to top.**
  ///
  /// Example:
  ///```dart
  /// promptReplacementBuilder: (context, function) {
  ///                   return MaterialButton(
  ///                     onPressed: () {
  ///                       function();
  ///                     },
  ///                     child: Text('Scroll to top'),
  ///                   );
  ///                 },
  ///```
  final ReplacementBuilder? promptReplacementBuilder;

  /// Modify the prompt theme by providing a custom [PromptButtonTheme].
  final PromptButtonTheme? promptTheme;

  /// Where on the widget to align the prompt.
  final Alignment promptAlignment;

  /// Duration it takes for the prompt to come into view/vanish.
  final Duration promptDuration;

  /// Animation Curve that the prompt will follow when coming into view.
  final Curve promptAnimationCurve;

  ScrollWrapper({
    Key? key,
    required this.scrollController,
    this.promptScrollOffset = 200,
    required this.child,
    this.promptDuration = const Duration(milliseconds: 500),
    this.promptAnimationCurve = Curves.fastOutSlowIn,
    this.promptAlignment = Alignment.topRight,
    this.promptTheme,
    this.promptReplacementBuilder,
  })  : assert(
            promptReplacementBuilder != null ? promptTheme == null : true,
            'promptTheme is not used if a custom prompt is being shown. '
            'Remove either the promptTheme or the promptReplacementBuilder.'),
        super(key: key);

  @override
  _ScrollWrapperState createState() => _ScrollWrapperState();
}

class _ScrollWrapperState extends State<ScrollWrapper> {
  late PromptButtonTheme promptTheme;

  @override
  void initState() {
    promptTheme = widget.promptTheme ?? PromptButtonTheme();
    super.initState();
  }

  bool scrollTopAtOffset = false;

  void scrollToTop() {
    widget.scrollController.animateTo(
        widget.scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels > widget.promptScrollOffset &&
            !scrollTopAtOffset)
          setState(() {
            scrollTopAtOffset = true;
          });
        else if (notification.metrics.pixels <= widget.promptScrollOffset &&
            scrollTopAtOffset)
          setState(() {
            scrollTopAtOffset = false;
          });
        return true;
      },
      child: widget.child,
    );
    child = Stack(
      children: [
        child,
        Align(
          alignment: widget.promptAlignment,
          child: SizeExpandedSection(
            expand: scrollTopAtOffset,
            duration: widget.promptDuration,
            curve: widget.promptAnimationCurve,
            alignment: widget.promptAlignment,
            child: widget.promptReplacementBuilder != null
                ? widget.promptReplacementBuilder!(context, scrollToTop)
                : Padding(
                    padding: promptTheme.promptPadding,
                    child: ClipOval(
                      child: Material(
                        type: MaterialType.circle,
                        color: promptTheme.promptColor ??
                            Theme.of(context).accentColor,
                        child: InkWell(
                          onTap: () {
                            scrollToTop();
                          },
                          child: Padding(
                            padding: promptTheme.promptIconPadding,
                            child: promptTheme.promptIcon ??
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
    return child;
  }
}

class PromptButtonTheme {
  /// Padding around the prompt button.
  final EdgeInsets promptPadding;

  /// Padding around the icon inside the button.
  final EdgeInsets promptIconPadding;

  /// Icon inside the button.
  final Icon? promptIcon;

  /// Color of the prompt button. Defaults to the accent color of the current
  /// context's [Theme].
  final Color? promptColor;

  /// Custom prompt button theme to be given to a [ScrollWrapper].
  PromptButtonTheme(
      {this.promptPadding =
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      this.promptIcon,
      this.promptIconPadding = const EdgeInsets.all(8.0),
      this.promptColor});
}
