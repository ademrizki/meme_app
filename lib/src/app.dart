import 'package:flutter/material.dart';
import 'package:meme_app/src/providers/auth/login.dart';
import 'package:meme_app/src/providers/auth/splash_provider.dart';
import 'package:meme_app/src/providers/content/add_content_provider.dart';
import 'package:meme_app/src/providers/dashboard/home.dart';
import 'package:meme_app/src/providers/profile/update_role.dart';
import 'package:meme_app/src/screens/auth/login.dart';
import 'package:meme_app/src/screens/auth/splash_screen.dart';
import 'package:meme_app/src/screens/content/add_content_screen.dart';
import 'package:meme_app/src/screens/dashboard/home.dart';
import 'package:meme_app/src/screens/profile/update_role.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meme Apps',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => ChangeNotifierProvider<SplashProvider>(
              create: (context) => SplashProvider(),
              child: SplashScreen(),
            ),
        LoginScreen.id: (context) => ChangeNotifierProvider<LoginProvider>(
              create: (context) => LoginProvider(),
              child: LoginScreen(),
            ),
        HomeScreen.id: (context) => ChangeNotifierProvider<HomeProvider>(
              create: (context) => HomeProvider(),
              child: HomeScreen(),
            ),
        UpdateRoleScreen.id: (context) => ChangeNotifierProvider<UpdateRoleProvider>(
              create: (context) => UpdateRoleProvider(),
              child: UpdateRoleScreen(),
            ),
        AddContentScreen.id: (context) => ChangeNotifierProvider<AddContentProvider>(
              create: (context) => AddContentProvider(),
              child: AddContentScreen(),
            ),
      },
    );
  }
}
