import 'package:flutter/material.dart';

class SettingPageItemComp extends StatelessWidget {
  final String text;
  final Widget item;
  const SettingPageItemComp({Key? key, this.text = '', required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: const Color(0xFFE0E0E0))),
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: item,
          )
        ],
      ),
    );
  }
}
