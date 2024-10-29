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
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Verificar si la pantalla está en modo portrait u horizontal
          bool isMobile = constraints.maxWidth < 600;
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;

          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/inoske.jpg'),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: isLandscape ? 50 : isMobile ? 100 : 150,
                  child: Image.asset(
                    'assets/logoKaito.png',
                    width: isLandscape ? 120 : isMobile ? 160 : 250,
                  ),
                ),
                Positioned(
                  top: isLandscape ? 150 : isMobile ? 250 : 300,
                  child: Container(
                    width: isLandscape
                        ? constraints.maxWidth * 0.6
                        : isMobile
                            ? constraints.maxWidth * 0.9
                            : 400,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: conUser,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Usuario',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: conPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            labelText: 'Contraseña',
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            minimumSize: Size(double.infinity, 50),
                          ),
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
                                          builder: (context) =>
                                              OnboardingScreen(),
                                        ),
                                      ),
                                    });
                          },
                          child: Text('Validar usuario'),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isloading)
                  Positioned(
                    top: isLandscape ? 30 : 80,
                    child: Image.asset(
                      'assets/loading.gif',
                      height: isLandscape ? 80 : 100,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
