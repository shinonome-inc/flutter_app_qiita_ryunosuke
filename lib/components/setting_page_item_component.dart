import 'package:flutter/material.dart';

class SettingPageItemComponent extends StatelessWidget {
  final String text;
  final Widget item;
  const SettingPageItemComponent({Key? key, this.text = '', required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0)))),
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(text),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: item,
          )
        ],
      ),
    );
  }
}
