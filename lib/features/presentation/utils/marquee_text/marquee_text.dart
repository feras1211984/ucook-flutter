library marquee_text;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ucookfrontend/features/presentation/utils/marquee_text/marquee_direction.dart';

class MarqueeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;

  /// default 50
  /// Must be greater than 0.
  final double speed;

  /// Always scroll and ignore text length.
  final bool alwaysScroll;

  final TextDirection textDirection;

  /// default rtl
  final MarqueeDirection marqueeDirection;

  const MarqueeText({
    Key? key,
    required this.text,
    this.style,
    this.align = TextAlign.center,
    this.speed = 50,
    this.alwaysScroll = false,
    this.textDirection = TextDirection.ltr,
    this.marqueeDirection = MarqueeDirection.rtl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      /// Remove color will cause parent widget's onTap to not work
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => ClipPath(
          child: _MarqueeContainer(
            text: text,
            textStyle: style,
            textAlign: align,
            constraints: constraints,
            speed: speed,
            alwaysScroll: alwaysScroll,
            textDirection: textDirection,
            marqueeDirection: marqueeDirection,
          ),
        ),
      ),
    );
  }
}

class _MarqueeContainer extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final double speed;
  final BoxConstraints constraints;
  final bool alwaysScroll;
  final TextDirection textDirection;
  final MarqueeDirection marqueeDirection;

  _MarqueeContainer({
    Key? key,
    required this.text,
    this.textStyle,
    this.textAlign,
    required this.constraints,
    required this.speed,
    required this.alwaysScroll,
    required this.textDirection,
    required this.marqueeDirection,
  }) : super(key: key);

  @override
  _MarqueeContainerState createState() => _MarqueeContainerState();
}

class _MarqueeContainerState extends State<_MarqueeContainer>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool _showMarquee = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var renderParagraph = RenderParagraph(
      TextSpan(
        text: widget.text,
        style: widget.textStyle,
      ),
      softWrap: false,
      maxLines: 1,
      textDirection: widget.textDirection,
      overflow: TextOverflow.visible,
    );
    renderParagraph.layout(widget.constraints);
    var textWidth = renderParagraph.textSize.width;
    var constraintsWidth = renderParagraph.constraints.maxWidth;
    _showMarquee = textWidth > constraintsWidth || widget.alwaysScroll;
    var tweenList = [constraintsWidth, -textWidth];
    if (_showMarquee) {
      if (widget.speed <= 0) {
        throw 'marquee_text speed value must be greater than 0';
      }
      var duration = ((textWidth / (widget.speed * 1.72)) * 1000).floor();
      _showMarquee = true;
      _animationController.duration = Duration(milliseconds: duration);
      _animation = Tween(
        begin: tweenList[widget.marqueeDirection.index],
        end: tweenList[1 - widget.marqueeDirection.index],
      ).animate(_animationController)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _animationController.repeat();
          }
        });
      _animationController.forward();
    }

    final textWidget = Text(
      widget.text,
      style: widget.textStyle,
      overflow: TextOverflow.visible,
      textAlign: widget.textAlign,
      softWrap: false,
      textDirection: widget.textDirection,
    );
    return _showMarquee
        ? AnimatedBuilder(
            builder: (context, myWidget) => Container(
              width: double.infinity,
              transform: Matrix4.translationValues(
                _animation.value,
                0.0,
                0.0,
              ),
              child: myWidget,
            ),
            animation: _animation,
            child: textWidget,
          )
        : textWidget;
  }
}
