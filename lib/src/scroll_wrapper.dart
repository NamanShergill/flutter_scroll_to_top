import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scroll_to_top/src/ui/expand_animation.dart';

typedef ReplacementBuilder = Widget Function(
    BuildContext context, VoidCallback function);

typedef ScrollBuilder = Widget Function(ScrollController scrollController);

/// Wrap the widget to show a scroll to top prompt over when a certain scroll
/// offset is reached.
class ScrollWrapper extends StatefulWidget {
  ScrollWrapper({
    Key? key,
    required this.builder,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    bool? primary,
    this.promptScrollOffset = 200,
    this.scrollToTopCurve = Curves.fastOutSlowIn,
    this.scrollToTopDuration = const Duration(milliseconds: 500),
    this.promptDuration = const Duration(milliseconds: 500),
    this.promptAnimationCurve = Curves.fastOutSlowIn,
    this.promptAlignment = Alignment.topRight,
    this.promptTheme,
    this.promptAnimationType = PromptAnimation.size,
    this.promptReplacementBuilder,
  })  : assert(
          !(scrollController != null && primary == true),
          'Primary ScrollViews obtain their ScrollController via inheritance from a PrimaryScrollController widget. '
          'You cannot both set primary to true and pass an explicit controller.',
        ),
        primary = primary ??
            scrollController == null &&
                identical(scrollDirection, Axis.vertical),
        super(key: key);

  /// [ScrollController] of the scrollable widget to scroll to the top of when
  /// the prompt is pressed.
  final ScrollController? scrollController;

  /// The widget to show the prompt over when scroll is at an offset.
  final ScrollBuilder builder;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether this is wrapped around a primary scroll view associated with the parent
  /// [PrimaryScrollController].
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool primary;

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

  @override
  _ScrollWrapperState createState() => _ScrollWrapperState();
}

class _ScrollWrapperState extends State<ScrollWrapper> {
  late PromptButtonTheme _promptTheme;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _promptTheme = widget.promptTheme ?? PromptButtonTheme();
  }

  @override
  void didChangeDependencies() {
    _setupScrollController();
    _setupListener();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ScrollWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.promptTheme != widget.promptTheme) {
      _promptTheme = widget.promptTheme ?? PromptButtonTheme();
    }
  }

  void _setupScrollController() {
    if (widget.primary) {
      _scrollController =
          PrimaryScrollController.of(context) ?? ScrollController();
    } else {
      _scrollController = widget.scrollController ?? ScrollController();
    }
  }

  void _setupListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset > widget.promptScrollOffset &&
          !scrollTopAtOffset)
        setState(() {
          scrollTopAtOffset = true;
        });
      else if (_scrollController.offset <= widget.promptScrollOffset &&
          scrollTopAtOffset)
        setState(() {
          scrollTopAtOffset = false;
        });
    });
  }

  bool scrollTopAtOffset = false;

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: widget.scrollToTopDuration,
      curve: widget.scrollToTopCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(_scrollController),
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
                    padding: _promptTheme.padding,
                    child: Material(
                      elevation: _promptTheme.elevation ??
                          Theme.of(context).appBarTheme.elevation ??
                          4,
                      clipBehavior: Clip.antiAlias,
                      type: MaterialType.circle,
                      color: _promptTheme.color ??
                          Theme.of(context).appBarTheme.backgroundColor ??
                          Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: scrollToTop,
                        child: Padding(
                          padding: _promptTheme.iconPadding,
                          child: _promptTheme.icon ??
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
