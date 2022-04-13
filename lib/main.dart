import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';
import 'package:projet_developement_nesquik/backend/database.dart';
import 'package:projet_developement_nesquik/page/homePage.dart';
import 'auth/firebase_user_provider.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'onboard/onboard_widget.dart';

void main() async {
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return Container(
  //     color: Color(0xFF72B0EA),
  //     child: Center(
  //       child: Text(
  //         'Restart Please..',
  //         style: TextStyle(
  //           fontSize: 30.0,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await FlutterFlowTheme.initialize();
  try {
    runApp(MyApp());
    var location = new Location();
    var currentLocation = await location.getLocation();
  } catch (e) {
    print("pas accepté");
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  Stream<ProjetDevFirebaseUser> userStream;
  ProjetDevFirebaseUser initialUser;
  bool displaySplashImage = true;

  void setLocale(Locale value) => setState(() => _locale = value);
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  void initState() {
    super.initState();
    userStream = projetDevFirebaseUserStream()
      ..listen((user) => initialUser ?? setState(() => initialUser = user));
    Future.delayed(
        Duration(seconds: 1), () => setState(() => displaySplashImage = false));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projet Dev',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('fr', '')],
      theme: ThemeData(brightness: Brightness.light),
      themeMode: _themeMode,
      home: initialUser == null || displaySplashImage
          ? Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: SpinKitRing(
                  color: Color(0xFF72B0EA),
                  size: 50,
                ),
              ),
            )
          : currentUser.loggedIn
              ? MapSample()
              : OnboardWidget(),
    );
  }
}
