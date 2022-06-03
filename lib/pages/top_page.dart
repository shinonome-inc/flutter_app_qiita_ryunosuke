import 'package:flutter/material.dart';

import 'package:flutter_app_qiita/service/qiita_client.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottom_navigationbar/bottom_navigation.dart';
import 'login_page.dart';

class TopPage extends StatefulWidget {
  final Uri? uri;
  const TopPage({Key? key, required this.uri}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  String? acessToken = '';

  bool isLoading = false;

  Future<void> login() async {
    isLoading = true;
    acessToken = await QiitaClient.getAccessToken();
    isLoading = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavigation(),
      ),
    );
  }

  @override
  void initState() {
    if (widget.uri != null) {
      login();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/qiita.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        Center(
          child: Column(
            children: [
              Expanded(flex: 3, child: Container()), //端末によって見え方に違いが現れないように
              Text(
                'Qiita Feed App',
                style: GoogleFonts.pacifico(
                  fontSize: 36.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                '-PlayGround-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              Expanded(flex: 4, child: Container()),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                      ),
                      builder: (context) {
                        return const LoginPage();
                      },
                    );
                  },
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen[900],
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 34.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigation(),
                      ),
                    );
                  },
                  child: const Text(
                    'ログインせずに利用する',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 81),
            ],
          ),
        ),
      ]),
    );
  }
}
