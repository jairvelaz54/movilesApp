import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:pmsn2024b/screens/login_screen.dart';
import 'package:pmsn2024b/screens/logout_screen.dart';
import 'package:pmsn2024b/screens/profile_screen.dart';
import 'package:pmsn2024b/settings/colors_settings.dart';
import 'package:pmsn2024b/settings/global_values.dart';
import 'package:pmsn2024b/settings/theme_settings.dart';
import 'package:provider/provider.dart';

import '../provider/test_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<TestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsSettings.navColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.access_alarm_outlined),
          ),
          GestureDetector(
            onTap: () {},
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Image.asset('assets/logoKaito.png'),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          switch (index) {
            case 1:
              return ProfileScreen();
            case 2:
              return LogoutScreen();
            default:
              return Container();
          }
        },
      ),
      drawer: myDrawer(testProvider),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.exit_to_app, title: 'Exit'),
        ],
        onTap: (int i) => setState(() {
          index = i;
        }),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(key: _key, children: [
        FloatingActionButton.small(
            heroTag: "btn1",
            onPressed: () {
              GlobalValues.themeMode.value = 0;
              ThemeSettings.lightTheme(); // Aplica el tema claro
            },
            child: const Icon(Icons.light_mode)),
        FloatingActionButton.small(
            heroTag: "btn2",
            onPressed: () {
              GlobalValues.themeMode.value = 1;
              ThemeSettings.darkTheme(); // Aplica el tema oscuro
            },
            child: const Icon(Icons.dark_mode)),
      ]),
    );
  }

  Widget myDrawer(TestProvider testProvider) {
    return Drawer(
      child: ListView(
        children: [
           UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://th.bing.com/th/id/R.d8f30f8c7f238ac844fd924dab66cc21?rik=%2bkLdjBuwc8kcXw&pid=ImgRaw&r=0"),
            ),
            accountName: Text(testProvider.name),
            accountEmail: Text('jair@gotchu.page'),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/db'),
            title: const Text('Movies List'),
            subtitle: const Text('Database of movies '),
            leading: const Icon(Icons.movie),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            title: const Text('Configuración de Tema'),
            leading: const Icon(Icons.color_lens),
            onTap: () {
              Navigator.pushNamed(context, '/theme');
            },
          ),
          ListTile(
            title: const Text('Popular Movies'),
            leading: const Icon(Icons.movie_filter_sharp),
            onTap: () {
              Navigator.pushNamed(context, '/popularMovies');
            },
          ),
        ],
      ),
    );
  }
}
