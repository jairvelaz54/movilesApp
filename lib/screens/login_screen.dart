import 'package:flutter/material.dart';
import 'package:pmsn2024b/screens/onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final conUser = TextEditingController();
  final conPassword = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    TextFormField txtUser = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: conUser,
      decoration: InputDecoration(prefixIcon: Icon(Icons.person)),
    );
    TextFormField txtPassword = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: conPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.password),
      ),
    );

    final ctnCredentials = Positioned(
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            txtUser,
            txtPassword,
          ],
        ),
      ),
    );
    final btnLogin = Positioned(
        top: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
            onPressed: () {
              setState(() {});
              isloading = true;
              Future.delayed(const Duration(milliseconds: 4000))
                  .then((value) => {
                        isloading = false,
                        setState(() {}),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnboardingScreen()),
                        )
                      });
            },
            child: const Text('Validar usuario')));
    final gifLoading = Positioned(
      top: 80,
      child: Image.asset('assets/loading.gif'),
      height: 100,
    );
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/inoske.jpg'))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 100,
                child: Image.asset(
                  'assets/logoKaito.png',
                  width: 160,
                )),
            ctnCredentials,
            btnLogin,
            isloading ? gifLoading : Container()
          ],
        ),
      ),
    );
  }
}
