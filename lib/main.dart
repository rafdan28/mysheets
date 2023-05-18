// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysheets_app/Model/Utente.dart';
import 'package:mysheets_app/View/HomepageView.dart';
import 'package:mysheets_app/View/LoginView.dart';
import 'package:mysheets_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nasconde la barra dei tasti virtuali
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await Utente.init();
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'GothamBold',
      ),
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          return false; // Disabilita l'azione predefinita di andare indietro(sistema)
        },
        child: const App(),
      ),
        routes: <String, WidgetBuilder>{
          '/login' : (BuildContext context) => const Login(),
          '/homepage' : (BuildContext context) => const Homepage(),
        }
    ),
  );
}
