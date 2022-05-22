import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';

class NotLoginPage extends StatelessWidget {
  const NotLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(text: 'Mypage', useBackButton: false),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 32.0,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: Container()),
              const Text(
                'ログインが必要です',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              const Text(
                'マイページの機能を利用するには \n ログインを行なっていただく必要があります。',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF828282),
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(flex: 4, child: Container()),
              SizedBox(
                height: 50.0,
                width: 327.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    child: const Text('ログインする'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }
}
