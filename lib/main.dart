import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Brahmachaitanya/middleware/authentication.dart';
import 'package:Brahmachaitanya/views/Auth/welcome_page.dart';
import 'package:Brahmachaitanya/views/Home/home_page.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constant/constants.dart';
import 'middleware/app_translation.dart';
import 'middleware/middleware.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.subscribeToTopic("Brahmachaitanya");
  NotificationService().requestPermission();
  NotificationService().checkNotifications();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  final String? local = prefs.getString('language');
  runApp(MyApp(
    local: local,
  ));
}

class MyApp extends StatelessWidget {
  final local;
  const MyApp({super.key, required this.local});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // translationsKeys: AppTranslation.translationsKeys,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('mr'),
        const Locale('en'),
      ],
      locale: local == null ? Locale('en') : Locale(local),
      translations: Translate(),
      debugShowCheckedModeBanner: false,
      title: 'Brahmachaitanya App',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: COLOR_SCHEME['primary'],
              secondary: COLOR_SCHEME['secondary'],
            ),
      ),
      getPages: appRoutes(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> check() async {
    var prefs = await SharedPreferences.getInstance();
    List<String>? adminInfo = prefs.getStringList('admin');
    User? user = FireAuth().getCurrentUser();
    print("object");
    bool isLoggedIn = adminInfo == null && user == null ? false : true;
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            bool flag = snapshot.data as bool;
            if (flag)
              return HomePage();
            else
              return WelcomePage();
          } else {
            return Center(
              child: Container(
                child: Text("Server Error"),
              ),
            );
          }
        }));
  }
}
