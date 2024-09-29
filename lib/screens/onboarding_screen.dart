import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmsn2024b/settings/theme_settings.dart';
import 'package:pmsn2024b/settings/global_values.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Bienvenido a la App",
          body:
              "Aquí te explicamos cómo funciona la aplicación de manera general.",
          image: Center(
            child: Image.asset('assets/logoKaito.png', height: 175.0),
          ),
        ),

        PageViewModel(
          title: "Configura el tema",
          bodyWidget: Column(
            children: [
              Text("Selecciona el tema que prefieras:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      GlobalValues.themeMode.value = 0;
                      ThemeSettings.lightTheme(); // Aplica el tema claro
                    },
                    child: Text("Claro"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      GlobalValues.themeMode.value = 1;
                      ThemeSettings.darkTheme(); // Aplica el tema oscuro
                    },
                    child: Text("Oscuro"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      GlobalValues.themeMode.value = 2;
                      ThemeSettings.customTheme(); // Aplica el tema oscuro
                    },
                    child: Text("Naranja"),
                  ),
                ],
              ),
            ],
          ),
          image: Icon(Icons.palette, size: 175, color: Colors.blueAccent),
        ),

        // Pantalla adicional
        PageViewModel(
          title: "Permisos de la App",
          body:
              "Para ofrecerte la mejor experiencia, la app necesita acceso a la cámara y a tu ubicación. Estos permisos son necesarios para funciones clave como tomar fotos y personalizar servicios según tu ubicación.",
          image: Icon(Icons.lock_open, size: 175, color: Colors.green),
          footer: ElevatedButton(
            onPressed: () async {
              // Solicitar permisos
              Map<Permission, PermissionStatus> statuses = await [
                Permission.camera,
                Permission.location,
              ].request();

              // Manejar la respuesta de los permisos
              if (statuses[Permission.camera]!.isGranted &&
                  statuses[Permission.location]!.isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("¡Permisos otorgados!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Algunos permisos fueron denegados.")),
                );
              }
            },
            child: Text("Otorgar permisos"),
          ),
        ),
      ],
      onDone: () {
        Navigator.of(context)
            .pushReplacementNamed('/home'); // Navega a la pantalla principal
      },
      onSkip: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      showSkipButton: true,
      skip: const Text("Saltar"),
      next: const Icon(Icons.arrow_forward),
      done:
          const Text("Empezar", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(22.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
