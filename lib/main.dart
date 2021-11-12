import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'presentation/screens/main_page.dart';

import 'configs/app_config.dart';
import 'configs/theme_config.dart';
import 'presentation/routes/page.route.dart';
import 'presentation/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      themeMode: ThemeMode.light,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      debugShowCheckedModeBanner: false,
      getPages: RoutePage.pages,
      initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.routeName : LoginScreen.routeName,
      supportedLocales: const [
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
    );
  }
}
