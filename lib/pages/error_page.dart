import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ErrorPage extends StatelessWidget {
  final Function() onTapReload;

  const ErrorPage({Key? key, required this.onTapReload}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 67,
              width: 67,
              child: Image.asset(
                'images/network_error.png',
              ),
            ),
            const SizedBox(height: 42.0),
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: SizedBox(
                height: 17.0,
                child: Text(
                  'ネットワークエラー',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              'お手数ですが電波の良い場所で \n 再度読み込みをお願いします',
              style: TextStyle(
                fontSize: 12.0,
                color: HexColor('#828282'),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 200),
            SizedBox(
              height: 50.0,
              width: 327.0,
              child: ElevatedButton(
                child: const Text('再度読み込みをする'),
                style: ElevatedButton.styleFrom(
                  primary: HexColor('#74C13A'),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  onTapReload();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
