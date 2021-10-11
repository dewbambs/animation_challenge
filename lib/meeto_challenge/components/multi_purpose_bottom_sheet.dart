import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

const double minHeight = 120;

class MultiPurposeBottomSheet extends StatefulWidget {
  MultiPurposeBottomSheet({Key? key}) : super(key: key);

  @override
  MultiPurposeBottomSheetState createState() => MultiPurposeBottomSheetState();
}

class MultiPurposeBottomSheetState extends State<MultiPurposeBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  double get maxHeight => MediaQuery.of(context).size.height;
  double midHeight = 340;

  late Tween<double> _heightTween;
  late Animation _heightAnimation;
  Animation heightTween(double min, double max) => Tween(begin: min, end: max).animate(_animationController);

  @override
  void initState() {
    super.initState();
    currentMin = minHeight;
    currentMax = midHeight;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _heightTween = Tween(begin: currentMin, end: currentMax);
    _heightAnimation = _heightTween.animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  late double currentMin;
  late double currentMax;

  @override
  Widget build(BuildContext context) {
    Widget _vSpace = SizedBox(height: 20);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          height: _heightAnimation.value,
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: child,
            ),
          ),
        );
      },
      child: OverflowBox(
        alignment: Alignment.topLeft,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Icon(Icons.horizontal_rule_rounded),
            _vSpace,
            Text(
              "300+ places to stay",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            _vSpace,
            Divider(thickness: 1),
            _vSpace,
            Text(
              "Review COVID-19 travel restriction before your book. Learn more",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  void _toggle() {
    final bool isOpen = _animationController.status == AnimationStatus.completed;

    // _animationController.fling(velocity: isOpen ? -1.5 : 1.5);

    print((_heightAnimation.value as double).round());
    if (_heightAnimation.value.round() == midHeight) {
      if (_animationController.isCompleted) {
        _heightTween.end = maxHeight;
        _animationController.reset();
        _heightTween.begin = midHeight;
      } else {
        _heightTween.begin = minHeight;
        // _animationController.reset();
        _heightTween.end = midHeight;
      }
    } else if (_heightAnimation.value.round() == maxHeight) {
      _heightTween.begin = maxHeight;
      _animationController.reset();
      _heightTween.end = midHeight;
    } else {
      _heightTween.begin = midHeight;
      _animationController.reset();
      _heightTween.end = minHeight;
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_heightAnimation.value.round() == midHeight) {
      if (details.primaryDelta! > 0) {
        _heightTween.begin = minHeight;
        _animationController.value = midHeight;
        _heightTween.end = midHeight;
      } else {
        _heightTween.begin = midHeight;
        _animationController.reset();
        _heightTween.end = maxHeight;
      }
    }

    _animationController.value -= details.primaryDelta! / _heightAnimation.value;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating || _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }
}
