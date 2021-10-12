import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double minHeight = 120;
const kSupportGreen = Colors.transparent;

class ScrollableBottomSheetChallenge extends StatefulWidget {
  ScrollableBottomSheetChallenge({Key? key}) : super(key: key);

  @override
  _ScrollableBottomSheetChallengeState createState() => _ScrollableBottomSheetChallengeState();
}

class _ScrollableBottomSheetChallengeState extends State<ScrollableBottomSheetChallenge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollcontroller;

  double get maxHeight => MediaQuery.of(context).size.height;
  double midHeight = 340;

  late Tween<double> _heightTween;
  late Animation _heightAnimation;

  late ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();
    currentMin = minHeight;
    currentMax = midHeight;

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _heightTween = Tween(begin: currentMin, end: currentMax);
    _heightAnimation = _heightTween.animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _scrollcontroller = ScrollController(initialScrollOffset: 0)
      ..addListener(() {
        // Check condition to stop the scroll and activate gesture detection
        if (_animationController.value < _animationController.upperBound ||
            _scrollcontroller.offset <= _scrollcontroller.position.minScrollExtent) {
          _scrollcontroller.animateTo(0, duration: Duration(milliseconds: 1), curve: Curves.linear);
          setState(() {
            _scrollPhysics = NeverScrollableScrollPhysics();
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollcontroller.dispose();
    super.dispose();
  }

  late double currentMin;
  late double currentMax;

  @override
  Widget build(BuildContext context) {
    Widget _vSpace = SizedBox(height: 22);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/meeto_challenge/Mapsicle Map.png",
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fitHeight,
          ),

          Positioned(
            child: ElevatedButton(
              onPressed: () async {
                _heightTween.begin = 200;
                _animationController.animateTo(0, duration: Duration(milliseconds: 600));
                await Future.delayed(Duration(milliseconds: 610));
                _animationController.reset();
                _heightTween.end = 600;
              },
              child: Text("Press to switch"),
            ),
          ),

          //! Expandable bottom sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    height: _heightAnimation.value,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: child,
                  );
                },
                child: Stack(
                  children: [
                    ListView(
                      controller: _scrollcontroller,
                      physics: _scrollPhysics,
                      shrinkWrap: true,
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
                        ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) => ListTile(
                            title: Text("test text"),
                            isThreeLine: true,
                            subtitle: Text("subtitle"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Handle animation to start only after midHeight
    if (_heightAnimation.value.round() == midHeight) {
      // going down from midHeight
      if (details.primaryDelta! > 0) {
        _heightTween.begin = minHeight;
        _animationController.value = midHeight;
        _heightTween.end = midHeight;
      } else {
        // going up from midHeight
        _heightTween.begin = midHeight;
        _animationController.reset();
        _heightTween.end = maxHeight;
      }
    }

    // Check multiple factors to enable scrolling
    // * 1. animation contoller is completely open
    // * 2. _heightTween == maxHeight which checks it's total open position and not the snap point
    // * 3. check primary delta which when negative which means user tried to scroll upwards
    if (_animationController.value >= _animationController.upperBound && details.primaryDelta! < 0) {
      setState(() {
        _scrollPhysics = BouncingScrollPhysics();
      });
    }

    _animationController.value -= details.primaryDelta! / _heightAnimation.value;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating || _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(1.5, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-1.5, -flingVelocity));
    else
      _animationController.fling(velocity: _animationController.value < 0.5 ? -1.5 : 1.5);
  }
}
