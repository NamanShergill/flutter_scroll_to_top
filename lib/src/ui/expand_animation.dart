import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';

class AnimatePrompt extends StatefulWidget {
  const AnimatePrompt(
      {required this.expand,
      required this.child,
      required this.animType,
      required this.curve,
      required this.duration,
      required this.alignment,
      Key? key})
      : super(key: key);
  final Widget child;
  final bool expand;
  final Alignment alignment;
  final Curve curve;
  final Duration duration;
  final PromptAnimation animType;

  @override
  AnimatePromptState createState() => AnimatePromptState();
}

class AnimatePromptState extends State<AnimatePrompt>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: widget.duration);
    animation = CurvedAnimation(
      parent: expandController,
      curve: widget.curve,
    );
    if (widget.expand) {
      _runExpandCheck();
    }
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(AnimatePrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animType == PromptAnimation.fade) {
      return FadeTransition(
        opacity: animation,
        child: widget.child,
      );
    } else if (widget.animType == PromptAnimation.scale) {
      return ScaleTransition(
        scale: animation,
        child: widget.child,
      );
    } else if (widget.animType == PromptAnimation.size) {
      return SizeTransition(
        sizeFactor: animation,
        child: Row(
          children: [
            Expanded(
                child: Align(alignment: widget.alignment, child: widget.child)),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
