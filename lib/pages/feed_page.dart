import 'package:flutter/material.dart';
import '../components/appbar_design.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Widget textField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 36.0,
      width: double.infinity,
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: 'Search',
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.white),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(text: 'Feed'),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            textField(),
            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
