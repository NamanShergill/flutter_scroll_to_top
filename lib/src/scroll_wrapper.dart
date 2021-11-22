import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scroll_to_top/src/ui/expand_animation.dart';

typedef ReplacementBuilder = Widget Function(
    BuildContext context, VoidCallback function);

typedef ScrollBuilder = Widget Function(
    BuildContext context, ScrollViewProperties properties);

/// Wrap the widget to show a scroll to top prompt over when a certain scroll
/// offset is reached.
class ScrollWrapper extends StatefulWidget {
  const ScrollWrapper({
    Key? key,
    required this.builder,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    bool? primary,
    this.reverse = false,
    this.onPromptTap,
    this.scrollOffsetUntilVisible = 200,
    this.scrollOffsetUntilHide = 200,
    this.enabledAtOffset = 500,
    this.alwaysVisibleAtOffset = false,
    this.scrollToTopCurve = Curves.fastOutSlowIn,
    this.scrollToTopDuration = const Duration(milliseconds: 500),
    this.promptDuration = const Duration(milliseconds: 500),
    this.promptAnimationCurve = Curves.fastOutSlowIn,
    this.promptAlignment,
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

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// Callback function to be executed when the prompt is tapped.
  final VoidCallback? onPromptTap;

  /// At what scroll offset to enable the prompt on.
  final double enabledAtOffset;

  /// If the prompt is to be always visible at the provided offset. Setting this
  /// to false only shows the prompt when the user starts scrolling upwards.
  /// Default value is false.
  final bool alwaysVisibleAtOffset;

  /// If [alwaysVisibleAtOffset] is false, what offset should the user scroll in
  /// the opposite direction (ex, upwards scroll on a non-reversed vertical
  /// ScrollView) before the prompt becomes visible.
  final double scrollOffsetUntilVisible;

  /// If [alwaysVisibleAtOffset] is false, at what offset should the user scroll
  /// before the prompt hides itself, if visible.
  final double scrollOffsetUntilHide;

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
  final Alignment? promptAlignment;

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
  late Alignment _promptAlignment;

  @override
  void initState() {
    super.initState();
    _promptTheme = widget.promptTheme ?? const PromptButtonTheme();
    _promptAlignment = widget.promptAlignment ?? _setPromptAlignment();
  }

  Alignment _setPromptAlignment() {
    if (identical(widget.scrollDirection, Axis.vertical)) {
      if (widget.reverse) {
        return Alignment.bottomRight;
      } else {
        return Alignment.topRight;
      }
    } else {
      if (widget.reverse) {
        return Alignment.topRight;
      } else {
        return Alignment.topLeft;
      }
    }
  }

  IconData _getDefaultIcon() {
    if (identical(widget.scrollDirection, Axis.vertical)) {
      if (widget.reverse) {
        return Icons.keyboard_arrow_down_rounded;
      } else {
        return Icons.keyboard_arrow_up_rounded;
      }
    } else {
      if (widget.reverse) {
        return Icons.keyboard_arrow_right_rounded;
      } else {
        return Icons.keyboard_arrow_left_rounded;
      }
    }
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
      _promptTheme = widget.promptTheme ?? const PromptButtonTheme();
    }
    if (oldWidget.promptAlignment != widget.promptAlignment ||
        oldWidget.primary != widget.primary ||
        oldWidget.scrollDirection != widget.scrollDirection) {
      _promptAlignment = widget.promptAlignment ?? _setPromptAlignment();
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

  double? _currentScrollUpOffset;
  double? _currentScrollDownOffset;

  void _setupListener() {
    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;
      if (widget.alwaysVisibleAtOffset) {
        _checkState();
      } else if (direction == ScrollDirection.forward) {
        _currentScrollUpOffset ??= _scrollController.offset;
        if (_currentScrollUpOffset! - _scrollController.offset >
            widget.scrollOffsetUntilVisible) {
          _checkState();
          _currentScrollDownOffset = null;
        }
      } else {
        _currentScrollDownOffset ??= _scrollController.offset;
        if (_scrollController.offset - _currentScrollDownOffset! >
            widget.scrollOffsetUntilHide) {
          if (mounted) {
            setState(() {
              _scrollTopAtOffset = false;
            });
          }
          _currentScrollUpOffset = null;
          _currentScrollDownOffset = null;
        }
      }
    });
  }

  void _checkState() {
    if (_scrollController.offset > widget.enabledAtOffset &&
        !_scrollTopAtOffset) {
      if (mounted) {
        setState(() {
          _scrollTopAtOffset = true;
        });
      }
    } else if (_scrollController.offset <= widget.enabledAtOffset &&
        _scrollTopAtOffset) {
      if (mounted) {
        setState(() {
          _scrollTopAtOffset = false;
        });
      }
    }
  }

  bool _scrollTopAtOffset = false;

  void _scrollToTop() {
    widget.onPromptTap?.call();
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
        widget.builder(
          context,
          ScrollViewProperties(
              reverse: widget.reverse,
              primary: widget.primary,
              scrollDirection: widget.scrollDirection,
              scrollController: _scrollController),
        ),
        Align(
          alignment: _promptAlignment,
          child: AnimatePrompt(
            expand: _scrollTopAtOffset,
            animType: widget.promptAnimationType,
            duration: widget.promptDuration,
            curve: widget.promptAnimationCurve,
            alignment: _promptAlignment,
            child: widget.promptReplacementBuilder != null
                ? widget.promptReplacementBuilder!(context, _scrollToTop)
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
                        onTap: _scrollToTop,
                        child: Padding(
                          padding: _promptTheme.iconPadding,
                          child: _promptTheme.icon ??
                              Icon(
                                _getDefaultIcon(),
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
  /// Custom prompt button theme to be given to a [ScrollWrapper].
  const PromptButtonTheme({
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.icon,
    this.iconPadding = const EdgeInsets.all(8.0),
    this.elevation,
    this.color,
  });

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
}

class ScrollViewProperties {
  const ScrollViewProperties(
      {required this.reverse,
      required this.primary,
      required this.scrollDirection,
      required ScrollController scrollController})
      : _scrollController = scrollController;
  final ScrollController _scrollController;
  final bool reverse;
  final bool primary;
  final Axis scrollDirection;

  ScrollController? get scrollController => primary ? null : _scrollController;
}

enum PromptAnimation { fade, scale, size }
