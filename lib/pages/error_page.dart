import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Function() onTapReload;
  const ErrorPage({Key? key, required this.onTapReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 67,
                      width: 67,
                      child: Image.asset(
                        'images/network_error.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 42.67, bottom: 6.0),
                      child: const Text(
                        'ネットワークエラー',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    const Text(
                      'お手数ですが電波の良い場所で \n 再度読み込みをお願いします',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  height: 50.0,
                  width: 327.0,
                  child: ElevatedButton(
                    child: const Text('再度読み込みをする'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      onTapReload();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
