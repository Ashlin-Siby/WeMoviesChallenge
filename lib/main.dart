import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:prac/presentation/pages/dashboard.page.dart';
import 'package:prac/presentation/pages/splash.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: const [
        LocaleNamesLocalizationsDelegate(),
        // ... more localization delegates
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'OpenSans',
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
