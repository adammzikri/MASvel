// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masvel/consts/theme_data.dart';
import 'package:masvel/provider/dark_theme_provider.dart';
import 'package:masvel/screens/auth/login.dart';
import 'package:masvel/screens/auth/signup.dart';
import 'package:masvel/screens/bottom_bar.dart';
import 'package:masvel/screens/categories.dart';
import 'package:masvel/screens/home_screens.dart';
import 'package:masvel/screens/user.dart';
import 'package:masvel/services/dark_theme_prefs.dart';
import 'package:provider/provider.dart';
import 'package:masvel/screens/nearMe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return themeChangeProvider;
        }),
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Masvel',
          theme: Styles.themeData(themeProvider.getDarkTheme, context),
          home: const LogInScreen(),
        );
      }),
    );
  }
}
