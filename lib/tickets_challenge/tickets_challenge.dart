import 'package:flutter/material.dart';
import 'package:flutter_advance_transition/tickets_challenge/components/Exhibition_bottom_sheet.dart';

class TicketChallenge extends StatelessWidget {
  const TicketChallenge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [Placeholder(), Placeholder()],
              ),
            ),
          ),
          ExhibitionBottomSheet()
        ],
      ),
    );
  }
}
