import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mojazahkam/screens/fontSetting.dart';
import 'package:provider/provider.dart';
import 'models/chapter.dart';
import 'models/favorites.dart';
import 'screens/chapter_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/search_screen.dart';
import 'screens/main_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadPreferences();
  runApp(MawjizAlAhkamApp());
}

class MawjizAlAhkamApp extends StatefulWidget {
  @override
  _MawjizAlAhkamAppState createState() => _MawjizAlAhkamAppState();
}


class _MawjizAlAhkamAppState extends State<MawjizAlAhkamApp> {
  bool isDarkMode = false;

  void toggleTheme(bool isDark) {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChapterProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GetMaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
          title: 'موجز الأحكام',
          theme: isDarkMode ? darkTheme : lightTheme,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: [Locale('ar', 'AE')],
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Splash(isDarkMode: isDarkMode, toggleTheme: toggleTheme),
          ),
          routes: {
            FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
          },
        ),
      ),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(color: Color.fromRGBO(239, 221, 171, 1)),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(color: Colors.black),
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
);

class Splash extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> toggleTheme;

  const Splash({Key? key, required this.isDarkMode, required this.toggleTheme})
      : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 2500), () {
      Get.off(MainScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.toggleTheme,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Image.asset(
          "assets/splashicon.png",
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

