/*import 'package:flutter/cupertino.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Cupertino App',
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Cupertino App Bar'),
        ),
        child: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() => runApp( MyApp());

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador=0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
            title: Text(
              'Mi primera App',
              style: TextStyle(color: Colors.green),
            ),
          ),
          body: Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                'Contador de clicks: $contador',
                textAlign: TextAlign.center,

              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.ads_click_sharp),
            onPressed: (){
            contador++;
            setState(() { });
            print(contador);
          }),
          ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:pmsn2024b/provider/test_provider.dart';
import 'package:pmsn2024b/screens/detail_popular_screen.dart';
import 'package:pmsn2024b/screens/home_screen.dart';
import 'package:pmsn2024b/screens/login_screen.dart';
import 'package:pmsn2024b/screens/movies_screen.dart';
import 'package:pmsn2024b/screens/popular_screen.dart';
import 'package:pmsn2024b/screens/theme_screen.dart';
import 'package:pmsn2024b/settings/global_values.dart';
import 'package:pmsn2024b/settings/theme_preferences.dart';
import 'package:pmsn2024b/settings/theme_settings.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  int savedTheme = await ThemePreference().getTheme();
  GlobalValues.themeMode.value = savedTheme;

  runApp(const MyApp());
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
              home: LoginScreen(),
              theme: getThemeByMode(themeMode),
              routes: {
                "/home": (context) => HomeScreen(),
                "/db": (context) => MoviesScreen(),
                "/theme": (context) => ThemeSettingsScreen(),
                "/popularMovies":(context) =>PopularScreen(),
                "/detail": (context) => DetailPopularScreen()
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
