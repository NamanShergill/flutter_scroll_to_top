import 'package:flutter/material.dart';

class SizeExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Alignment alignment;
  final Curve curve;
  final Duration duration;
  SizeExpandedSection(
      {required this.expand,
      required this.child,
      required this.curve,
      required this.duration,
      required this.alignment,
      Key? key})
      : super(key: key);

  @override
  _SizeExpandedSectionState createState() => _SizeExpandedSectionState();
}

class _SizeExpandedSectionState extends State<SizeExpandedSection>
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
    if (widget.expand) _runExpandCheck();
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(SizeExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  MainAxisAlignment mainAxisAlignment(Alignment alignment) {
    if (alignment == Alignment.topCenter ||
        alignment == Alignment.center ||
        alignment == Alignment.bottomCenter)
      return MainAxisAlignment.center;
    else if (alignment == Alignment.topLeft ||
        alignment == Alignment.centerLeft ||
        alignment == Alignment.bottomLeft)
      return MainAxisAlignment.start;
    else if (alignment == Alignment.topRight ||
        alignment == Alignment.centerRight ||
        alignment == Alignment.bottomRight) return MainAxisAlignment.end;
    return MainAxisAlignment.center;
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Row(
        children: [
          Expanded(
              child: Align(alignment: widget.alignment, child: widget.child)),
        ],
      ),
    );
  }
}
