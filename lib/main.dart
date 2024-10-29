import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pmsn2024b/database/servicio_database.dart';
import 'package:pmsn2024b/provider/test_provider.dart';
import 'package:pmsn2024b/screens/CalendarPage_screen.dart';
import 'package:pmsn2024b/screens/detail_popular_screen.dart';
import 'package:pmsn2024b/screens/home_screen.dart';
import 'package:pmsn2024b/screens/login_screen.dart';
import 'package:pmsn2024b/screens/movies_screen.dart';
import 'package:pmsn2024b/screens/newSalePage_screen.dart';
import 'package:pmsn2024b/screens/popular_screen.dart';
import 'package:pmsn2024b/screens/theme_screen.dart';
import 'package:pmsn2024b/settings/global_values.dart';
import 'package:pmsn2024b/settings/theme_preferences.dart';
import 'package:pmsn2024b/settings/theme_settings.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa `android_alarm_manager_plus`
  await AndroidAlarmManager.initialize();

  // Configura `flutter_local_notifications`
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);



  // Inicializa el tema de la aplicación
  int savedTheme = await ThemePreference().getTheme();
  GlobalValues.themeMode.value = savedTheme;
  runApp(const MyApp());
}

// Función para mostrar una notificación

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.themeMode,
        builder: (context, themeMode, _) {
          return ChangeNotifierProvider(
            create: (context) => TestProvider(),
            child: MaterialApp(
              title: 'Material App',
              debugShowCheckedModeBanner: false,
              home: LoginScreen(),
              theme: getThemeByMode(themeMode),
              routes: {
                "/home": (context) => HomeScreen(),
                "/db": (context) => MoviesScreen(),
                "/theme": (context) => ThemeSettingsScreen(),
                "/popularMovies": (context) => PopularScreen(),
                "/detail": (context) => DetailPopularScreen(),
                "/calendario": (context) => CalendarPage(),
                "/registrar": (context) => NewSalePage(),
              },
            ),
          );
        });
  }

  ThemeData getThemeByMode(int mode) {
    switch (mode) {
      case 1:
        return ThemeSettings.darkTheme();
      case 2:
        return ThemeSettings.customTheme();
      default:
        return ThemeSettings.lightTheme();
    }
  }
}


