import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';
import 'dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF121212),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF121212),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const TurboVetsApp());
}

class TurboVetsApp extends StatefulWidget {
  const TurboVetsApp({Key? key}) : super(key: key);

  @override
  State<TurboVetsApp> createState() => _TurboVetsAppState();
}

class _TurboVetsAppState extends State<TurboVetsApp> {
  bool _loaded = false;
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('darkMode');
    setState(() {
      _isDark = saved ?? true; // default to dark if unset
      _loaded = true;
    });
  }

  Future<void> _setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    setState(() => _isDark = isDark);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: Colors.blueAccent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1E1E1E),
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );

    final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.grey[50],
      primaryColor: Colors.blue,
    );

    return MaterialApp(
      title: 'TurboVets',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: Home(isDark: _isDark, onThemeChanged: _setTheme),
    );
  }
}

class Home extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const Home({Key? key, required this.isDark, required this.onThemeChanged})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<String> _titles = ["Messaging", "Dashboard"];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // build screens each build so updated isDark is passed down
    final screens = <Widget>[
      const ChatScreen(),
      DashboardScreen(
        isDark: widget.isDark,
        onWebThemeChanged: (bool newDark) {
          // when web page informs change, update the stored theme in parent
          widget.onThemeChanged(newDark);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messaging',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
