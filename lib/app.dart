// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mysheets_app/Altro/Api.dart';
import 'package:mysheets_app/Model/Utente.dart';
import 'package:mysheets_app/View/HomepageView.dart';
import 'package:mysheets_app/View/LoginView.dart';
import 'package:mysheets_app/View/NewActivityView.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<bool> token = getToken();

    final Widget defaultHome = FutureBuilder<bool>(
      future: token,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == false ? const Login() : const Homepage();
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    return MaterialApp(
      title: 'MySheets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gotham'
      ),
      home: defaultHome,
      routes: <String, WidgetBuilder>{
        '/login' : (BuildContext context) => new Login(),
        '/homepage' : (BuildContext context) => new Homepage(),
      }
    );
  }

  Future<bool> getToken() async {
    if(Utente.remember == true) {
      final token = Utente.token;
      if (token == null) return false;
      final verifica = await Api.verificaToken(token.toString());
      log('Utente: ${verifica.body}');
      if (verifica.body == "Token non valido" ||
          verifica.body == "Token scaduto") {
        return false;
      }
      return true;
    }
    return false;
  }

  Future<bool> checkInternetPermission() async {
    var status = await PermissionHandlerPlatform.instance
        .checkPermissionStatus(Permission.location);
    if (status != PermissionStatus.granted) {
      var result = await PermissionHandlerPlatform.instance
          .requestPermissions([Permission.location]);
      if (result[Permission.location] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
