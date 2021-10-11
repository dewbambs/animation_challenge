import 'package:flutter/material.dart';
import 'package:flutter_advance_transition/meeto_challenge/components/multi_purpose_bottom_sheet.dart';

const double _searchBorder = 0;
const kSupportGreen = Colors.transparent;

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
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

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16 + MediaQuery.of(context).padding.top, 16, 16),
        color: Colors.amber,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFD5D5D5), width: 1),
              borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(Icons.search_outlined),
              Flexible(child: _textField),
              VerticalDivider(thickness: 1),
              Icon(Icons.filter_list_outlined)
            ],
          ),
        ),
      ),
    );
  }
}
