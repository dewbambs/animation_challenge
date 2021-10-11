import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double minHeight = 120;
const double _searchBorder = 0;
const kSupportGreen = Colors.transparent;

const List<BoxShadow> smallReverse = [
  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), spreadRadius: 0, blurRadius: 4, offset: Offset(0, -4)),
  BoxShadow(color: Colors.white10, spreadRadius: 0, blurRadius: 0, offset: Offset(0, 0)),
];

class MeetoChallenge extends StatefulWidget {
  MeetoChallenge({Key? key}) : super(key: key);

  @override
  _MeetoChallengeState createState() => _MeetoChallengeState();
}

class _MeetoChallengeState extends State<MeetoChallenge> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  double get maxHeight => MediaQuery.of(context).size.height;
  double midHeight = 340;

  late Tween<double> _heightTween;
  late Animation _heightAnimation;

  late ColorTween _colorTween;
  late Animation _colorAnimation;

  late ColorTween _borderColorTween;
  late Animation _borderAnimation;

  late ColorTween _shadowTween;
  late Animation _shadowAnimation;

  late List<BoxShadow> smallShadow;

  @override
  void initState() {
    super.initState();
    currentMin = minHeight;
    currentMax = midHeight;

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _heightTween = Tween(begin: currentMin, end: currentMax);
    _heightAnimation = _heightTween.animate(_animationController);

    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.transparent);
    _colorAnimation = _colorTween.animate(_animationController);

    _borderColorTween = ColorTween(begin: Color(0xFFD5D5D5), end: Color(0xFFD5D5D5));
    _borderAnimation = _borderColorTween.animate(_animationController);

    _shadowTween = ColorTween(begin: Color.fromRGBO(0, 0, 0, 0.0), end: Color.fromRGBO(0, 0, 0, 0.0));
    _shadowAnimation = _shadowTween.animate(_animationController);
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
    Widget _vSpace = SizedBox(height: 22);

    Widget _textField = TextField(
      decoration: InputDecoration(
        labelText: "Search",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_searchBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(_searchBorder)),
          borderSide: BorderSide(width: 2.5, color: kSupportGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(_searchBorder)),
          borderSide: BorderSide(width: 2, color: kSupportGreen),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(_searchBorder)),
            borderSide: BorderSide(width: 1, color: kSupportGreen)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(_searchBorder)),
            borderSide: BorderSide(width: 1, color: kSupportGreen)),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/meeto_challenge/Mapsicle Map.png",
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
            ),

            // Expandable bottom sheet
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  height: _heightAnimation.value,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    // onTap: _toggle,
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: smallReverse,
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
                    // Text(
                    //   "Review COVID-19 travel restriction before your book. Learn more",
                    //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

                    // )
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 100,
                      itemBuilder: (context, index) => ListTile(
                        title: Text("test text"),
                        isThreeLine: true,
                        subtitle: Text("subtitle"),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Search box
            SearchBox(
                animationController: _animationController,
                colorAnimation: _colorAnimation,
                shadowAnimation: _shadowAnimation,
                borderAnimation: _borderAnimation,
                textField: _textField)
          ],
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Handle animation to start only after midHeight
    if (_heightAnimation.value.round() == midHeight) {
      // going down from midHeight
      if (details.primaryDelta! > 0) {
        _heightTween.begin = minHeight;

        _colorTween.begin = Colors.white10;
        _colorTween.end = Colors.white10;

        _animationController.value = midHeight;
        _heightTween.end = midHeight;

        _borderColorTween.end = Color(0xFFD5D5D5);

        _shadowTween.end = Color.fromRGBO(0, 0, 0, 0.0);
      } else {
        // going up from midHeight

        _heightTween.begin = midHeight;

        _colorTween.begin = Colors.white10;
        _colorTween.end = Colors.white;

        _animationController.reset();
        _heightTween.end = maxHeight;

        _borderColorTween.end = Colors.white;

        _shadowTween.end = Color.fromRGBO(0, 0, 0, 0.1);
      }
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

// Search box
class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
    required AnimationController animationController,
    required Animation colorAnimation,
    required Animation shadowAnimation,
    required Animation borderAnimation,
    required Widget textField,
  })  : _animationController = animationController,
        _colorAnimation = colorAnimation,
        _shadowAnimation = shadowAnimation,
        _borderAnimation = borderAnimation,
        _textField = textField,
        super(key: key);

  final AnimationController _animationController;
  final Animation _colorAnimation;
  final Animation _shadowAnimation;
  final Animation _borderAnimation;
  final Widget _textField;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.fromLTRB(16, 16 + MediaQuery.of(context).padding.top, 16, 16),
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              boxShadow: [
                BoxShadow(color: _shadowAnimation.value, spreadRadius: 0, blurRadius: 4, offset: Offset(0, 4)),
                BoxShadow(color: _shadowAnimation.value, spreadRadius: 0, blurRadius: 0, offset: Offset(0, 0)),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _borderAnimation.value, width: 1),
                  borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: child,
            ),
          );
        },
        child: Row(
          children: [
            Icon(Icons.search_outlined),
            Flexible(child: _textField),
            VerticalDivider(thickness: 1),
            Icon(Icons.filter_list_outlined)
          ],
        ),
      ),
    );
  }
}
