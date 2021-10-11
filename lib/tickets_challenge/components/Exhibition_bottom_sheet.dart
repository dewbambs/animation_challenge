import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

const double minHeight = 120;
const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class ExhibitionBottomSheet extends StatefulWidget {
  const ExhibitionBottomSheet({Key? key}) : super(key: key);

  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  double get maxHeight => MediaQuery.of(context).size.height;
  double get midHeight => MediaQuery.of(context).size.height / 2;
  double lerp(double min, double max) => lerpDouble(min, max, _animationController.value)!;

  double get headerTopMargin => lerp(20, 20 + MediaQuery.of(context).padding.top);

  double get headerFontSize => lerp(14, 24);

  double get itemBorderRadius => lerp(8, 24); //<-- increase item border radius

  double get iconSize => lerp(iconStartSize, iconEndSize); //<-- increase icon size

  double get iconLeftBorderRadius => itemBorderRadius; //<-- Left border radius stays the same

  double get iconRightBorderRadius => lerp(8, 0); //<-- Right border radius lerps to 0 instead.

  double iconTopMargin(int index) =>
      lerp(iconStartMarginTop, iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize)) +
      headerTopMargin; //<-- calculate top margin based on header margin, and size of all of icons above (from small to big)

  double iconLeftMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0); //<-- calculate left margin (from big to small)

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          height: lerp(minHeight, maxHeight),
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF162A49),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Stack(
                children: [
                  SheetHeader(
                    fontSize: headerFontSize,
                    topMargin: headerTopMargin,
                  ),
                  for (Event event in events) _buildFullItem(event),
                  for (Event event in events) _buildIcon(event)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggle() {
    final bool isOpen = _animationController.status == AnimationStatus.completed;
    _animationController.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta! / maxHeight;
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

  Widget _buildIcon(Event event) {
    int index = events.indexOf(event); //<-- Get index of the event
    return Positioned(
      height: iconSize, //<-- Specify icon's size
      width: iconSize, //<-- Specify icon's size
      top: iconTopMargin(index), //<-- Specify icon's top margin
      left: iconLeftMargin(index), //<-- Specify icon's left margin
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(itemBorderRadius), //<-- Set the rounded corners
          right: Radius.circular(itemBorderRadius),
        ),
        child: Image.asset(
          'assets/${event.assetName}',
          fit: BoxFit.cover,
          alignment: Alignment(lerp(1, 0), 0), //<-- Play with alignment for extra style points
        ),
      ),
    );
  }

  Widget _buildFullItem(Event event) {
    int index = events.indexOf(event);
    return ExpandedEventItem(
      topMargin: iconTopMargin(index), //<--provide margins and height same as for icon
      leftMargin: iconLeftMargin(index),
      height: iconSize,
      isVisible: _animationController.status == AnimationStatus.completed, //<--set visibility
      borderRadius: itemBorderRadius, //<-- pass border radius
      title: event.title, //<-- data to be displayed
      date: event.date, //<-- data to be displayed
    );
  }
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader({Key? key, required this.fontSize, required this.topMargin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      child: Text(
        'Booked Exhibition',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

final List<Event> events = [
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
];

class Event {
  final String assetName;
  final String title;
  final String date;

  Event(this.assetName, this.title, this.date);
}

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final String date;

  const ExpandedEventItem({
    Key? key,
    required this.topMargin,
    required this.height,
    required this.isVisible,
    required this.borderRadius,
    required this.title,
    required this.date,
    required this.leftMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: height).add(EdgeInsets.all(8)),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              '1 ticket',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: <Widget>[
            Icon(
              Icons.place,
              color: Colors.grey.shade400,
              size: 16,
            ),
            Text(
              'Science Park 10 25A',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
            )
          ],
        )
      ],
    );
  }
}
