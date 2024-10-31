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
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa el paquete de notificaciones locales
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inicializa las zonas horarias para programar notificaciones
  tz.initializeTimeZones();

  // Inicializa el tema de la aplicación
  int savedTheme = await ThemePreference().getTheme();
  GlobalValues.themeMode.value = savedTheme;

  runApp(const MyApp());
}

// Función para programar una notificación local
Future<void> scheduleNotification(DateTime date, String title, String body) async {
  final notificationTime = date.subtract(const Duration(days: 1)); // Un día antes

  if (notificationTime.isAfter(DateTime.now())) { // Solo programar si es una fecha futura
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal1', 'prueba', 
          channelDescription: 'prueba',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}

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
            home: const LoginScreen(),
            theme: getThemeByMode(themeMode),
            routes: {
              "/home": (context) => const HomeScreen(),
              "/db": (context) => const MoviesScreen(),
              "/theme": (context) => const ThemeSettingsScreen(),
              "/popularMovies": (context) => const PopularScreen(),
              "/detail": (context) => const DetailPopularScreen(),
              "/calendario": (context) => const CalendarPage(),
              "/registrar": (context) => const NewSalePage(),
            },
          ),
        );
      },
    );
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
