import 'package:flutter/material.dart';
import 'package:profile/screens/screens.dart';
import 'package:provider/provider.dart';

import 'services/services.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PetsService()),
          ChangeNotifierProvider(create: (_) => AuthService()),
        ],
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationsService.scaffoldMessengerKey,
      title: 'Login Form',
      initialRoute: 'login',
      routes: {
        'login': ( _ ) => const LoginScreen(),
        'register': ( _ ) => const RegisterScreen(),
        'home': ( _ ) => const HomeScreen(),
        'pets': ( _ ) => const PetsScreen(),
        'check_auth': ( _ ) => const CheckAuthScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme:  const AppBarTheme(
          elevation: 0,
          color: Colors.pinkAccent,
          iconTheme: IconThemeData(color: Colors.black87),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          )
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          focusColor: Colors.pink,
          hoverColor: Colors.pink,
          highlightElevation: 0,
        ),
      ),
    );
  }
}
