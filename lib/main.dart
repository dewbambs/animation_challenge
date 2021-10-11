import 'package:flutter/material.dart';
import 'package:flutter_advance_transition/scollable_bottom_sheet/scrollable_bottom_sheet.dart';

import 'meeto_challenge/meeto_challenge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScrollableBottomSheetChallenge(),
    );
  }
}
