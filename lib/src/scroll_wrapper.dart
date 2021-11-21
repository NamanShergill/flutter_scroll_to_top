import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/src/ui/expand_animation.dart';

typedef ReplacementBuilder = Widget Function(
    BuildContext context, VoidCallback function);

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

  /// Duration it takes for the page to scroll to the top on prompt button press.
  final Duration scrollToTopDuration;

  /// Animation Curve for scrolling to the top.
  final Curve scrollToTopCurve;

  /// Animation Curve that the prompt will follow when coming into view.
  final Curve promptAnimationCurve;

  /// [PromptAnimation] type that the prompt will follow when coming into view.
  /// Default is [PromptAnimation.size].
  final PromptAnimation promptAnimationType;

  ScrollWrapper({
    Key? key,
    required this.scrollController,
    this.promptScrollOffset = 200,
    required this.child,
    this.scrollToTopCurve = Curves.fastOutSlowIn,
    this.scrollToTopDuration = const Duration(milliseconds: 500),
    this.promptDuration = const Duration(milliseconds: 500),
    this.promptAnimationCurve = Curves.fastOutSlowIn,
    this.promptAlignment = Alignment.topRight,
    this.promptTheme,
    this.promptAnimationType = PromptAnimation.size,
    this.promptReplacementBuilder,
  }) : super(key: key);

  @override
  _ScrollWrapperState createState() => _ScrollWrapperState();
}

class _ScrollWrapperState extends State<ScrollWrapper> {
  late PromptButtonTheme promptTheme;

  @override
  void initState() {
    super.initState();
    promptTheme = widget.promptTheme ?? PromptButtonTheme();
  }

  @override
  void didUpdateWidget(covariant ScrollWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.promptTheme != widget.promptTheme) {
      promptTheme = widget.promptTheme ?? PromptButtonTheme();
    }
  }

  bool scrollTopAtOffset = false;

  void scrollToTop() {
    widget.scrollController.animateTo(
      widget.scrollController.position.minScrollExtent,
      duration: widget.scrollToTopDuration,
      curve: widget.scrollToTopCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child() {
      return NotificationListener<ScrollNotification>(
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
    }

    return Stack(
      children: [
        child(),
        Align(
          alignment: widget.promptAlignment,
          child: SizeExpandedSection(
            expand: scrollTopAtOffset,
            animType: widget.promptAnimationType,
            duration: widget.promptDuration,
            curve: widget.promptAnimationCurve,
            alignment: widget.promptAlignment,
            child: widget.promptReplacementBuilder != null
                ? widget.promptReplacementBuilder!(context, scrollToTop)
                : Padding(
                    padding: promptTheme.padding,
                    child: Material(
                      elevation: promptTheme.elevation ??
                          Theme.of(context).appBarTheme.elevation ??
                          4,
                      clipBehavior: Clip.antiAlias,
                      type: MaterialType.circle,
                      color: promptTheme.color ??
                          Theme.of(context).appBarTheme.backgroundColor ??
                          Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: scrollToTop,
                        child: Padding(
                          padding: promptTheme.iconPadding,
                          child: promptTheme.icon ??
                              Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: Theme.of(context)
                                        .appBarTheme
                                        .foregroundColor ??
                                    Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class PromptButtonTheme {
  /// Padding around the prompt button.
  final EdgeInsets padding;

  /// Elevation of the button.
  final double? elevation;

  /// Padding around the icon inside the button.
  final EdgeInsets iconPadding;

  /// Icon inside the button.
  final Icon? icon;

  /// Color of the prompt button. Defaults to the accent color of the current
  /// context's [Theme].
  final Color? color;

  /// Custom prompt button theme to be given to a [ScrollWrapper].
  PromptButtonTheme({
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.icon,
    this.iconPadding = const EdgeInsets.all(8.0),
    this.elevation,
    this.color,
  });
}

enum PromptAnimation { fade, scale, size }
