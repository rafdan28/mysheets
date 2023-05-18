import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mysheets_app/Altro/Api.dart';
import 'package:mysheets_app/Altro/LoginRequest.dart';
import 'package:mysheets_app/Altro/MyColor.dart';
import 'package:mysheets_app/Model/Utente.dart';
import 'package:mysheets_app/View/HomepageView.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureTextPassword = true;

  late PageController _pageController;
  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();
  bool isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _pageController.dispose();
    super.dispose();
    // Nascondi la barra delle notifiche e la barra di navigazione
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(64.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [MyColor.gradientLoginStart,MyColor.gradientLoginEnd],
                begin: FractionalOffset(0.0, 0.4),
                end: FractionalOffset(0.0, 1.0)
            ),
          ),
          child: Column(
            children: [
              logoApp(),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        formWidget(),
                        loginButton(),
                        Visibility(
                          visible: isLoading,
                          child: const Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(MyColor.circularProgressIndicator),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget logoApp() => const Padding(
    padding: EdgeInsets.only(top: 50.0),
    child: Image(
      image: AssetImage('assets/images/logosms.png'),
      height: 120.0,
    ),
  );

  Widget formWidget() => Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Card(
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
        width: 300.0,
        child: Column(
          children: [
            _usernameField(),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 1,
              width: 290,
              color: Colors.grey,
            ), //divide username e pw
            _passwordField(),
            _ricordamiField(),
          ],
        ),
      ),
    ),
  );

  Widget _usernameField() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
    child: TextField(
      controller: usernameController,
      focusNode: _focusNodeEmail,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Username',
        hintStyle: TextStyle(fontSize: 17.0),
        icon: Icon(
            CupertinoIcons.person_fill,
            color: Colors.black,
            size: 25.0
        ),
      ),
      onSubmitted: (_) {
        _focusNodePassword.requestFocus();
      }, //ci offre la stringa del testo inviato
    ),
  );

  Widget _passwordField() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
    child: TextField(
      controller: passwordController,
      focusNode: _focusNodePassword,
      obscureText: _obscureTextPassword,
      //per nascondere il contenuto della password
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Password',
        hintStyle: const TextStyle(fontSize: 17.0),
        icon: const Icon(
            CupertinoIcons.lock_fill,
            color: Colors.black,
            size: 25.0
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureTextPassword = !_obscureTextPassword;
            });
          },
          child: Icon(
              _obscureTextPassword
                  ? CupertinoIcons.eye_fill
                  : CupertinoIcons.eye_slash_fill,
              size: 20.0,
              color: Colors.black
          ),
        ),
      ),
      onSubmitted: (_) {
        //TODO: Login
      },
      textInputAction: TextInputAction.go,
    ),
  );

  Widget _ricordamiField() => Padding(
    padding: const EdgeInsets.only(top: 0.0, left: 45.0, right: 0.0),
    child: Theme(
      data: Theme.of(context).copyWith(
        visualDensity: VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text(
          "Ricordami",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
        ),
        value: rememberMe,
        onChanged: (bool? value) {
          setState(() {
            rememberMe = value!;
          });
        },
      ),
    ),
  );

  Widget loginButton() => Container(
    width: 200.0,
    height: 48.0,
    margin: const EdgeInsets.only(top: 16.0),
    decoration: BoxDecoration(
      // gradient: const LinearGradient(
      //   colors: [
      //     MyColor.gradientButtonAccediStart,
      //     MyColor.gradientButtonAccediEnd,
      //   ],
      //   begin: Alignment.centerLeft,
      //   end: Alignment.centerRight,
      // ),
      color: MyColor.gradientLoginEnd,
      borderRadius: BorderRadius.circular(24.0),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10.0,
          offset: Offset(0.0, 10.0),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          setState(() {
            isLoading = true; // mostro l'icona di caricamento
          });
          //Login
          switch (await login()) {
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Homepage(),
                ),
              );
              break;
            case 2:
              // Login failed
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Attenzione...'),
                  content: const Text('Password errata'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
              break;
            case 3:
              // Login failed
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Attenzione...'),
                  content: const Text('Username errato'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
              break;
          }
          setState(() {
            isLoading = false; // nascondo l'icona di caricamento
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              FontAwesomeIcons.signInAlt,
              color: Colors.white,
              size: 22.0,
            ),
            SizedBox(width: 16.0),
            Text(
              'Accedi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );

Future<int> login() async {
  final response = await Api.getUtenteByUsername(usernameController.text);
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  log('Login message: ${jsonResponse['success']}');

  if (jsonResponse['success'] == true && jsonResponse['message'] == "Utente trovato" && response.statusCode == 200) {
    //Utente trovato correttamente
    LoginRequest loginRequest = LoginRequest(usernameController.text, passwordController.text);
    final response = await Api.login(loginRequest);
    jsonResponse = json.decode(response.body);
    log('Login Response: $jsonResponse');

    if (jsonResponse['success'] == true && jsonResponse['message'] == "Utente autenticato" && response.statusCode == 200) {
      // Login successful
      final utente = jsonResponse['utente'][0];
      Utente.codiceLogin = utente['codiceLogin'];
      Utente.codicePersona = utente['codicePersona'];
      Utente.username = utente['username'];
      Utente.nome = utente['nome'];
      Utente.cognome = utente['cognome'];
      Utente.password = utente['password'];
      Utente.azienda = utente['azienda'];
      Utente.token = utente['token'];
      Utente.remember = rememberMe;

      return 1; //Homepage
    }
    else {
      //Password errata
      return 2;
    }
  }
  else {
    //Username errato
    return 3;
  }
}
}
