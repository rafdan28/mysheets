// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mysheets_app/Altro/Api.dart';
import 'package:mysheets_app/Altro/MyColor.dart';
import 'package:mysheets_app/Model/Attivita.dart';
import 'package:mysheets_app/Model/Utente.dart';
import 'package:mysheets_app/View/DetailActivityView.dart';
import 'package:mysheets_app/View/NewActivityView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late DateTime _selectedDay;
  late CalendarController _controller;
  late Map<String, dynamic> jsonResponse;
  List<Attivita> attivitaList = [];

  bool _isCalendarVisible = true;


  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _controller = CalendarController();
    _selectedDay = DateTime.now();
    loadActivity();
    // Nascondi la navbar del telefono
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(color: Colors.black, fontWeight: fontWeight);
  }

  Container activityList(String title, String description, String oreLavorate, String oreInizioAttivita, String oreFineAttivita) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          const Icon(
            CupertinoIcons.briefcase,
            color: Colors.white,
            size: 25,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.time,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$oreLavorate"+"h | $oreInizioAttivita > $oreFineAttivita",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -20) {
          setState(() {
            _isCalendarVisible = false;
          });
        } else if (details.delta.dy > 20) {
          setState(() {
            _isCalendarVisible = true;
          });
        }
      },
      child: Column(
        children: [
          if (_isCalendarVisible)
            TableCalendar(
              locale: Localizations.localeOf(context).languageCode,
              availableGestures: AvailableGestures.none,
              calendarController: _controller,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                weekdayStyle: dayStyle(FontWeight.normal),
                selectedColor: Colors.black,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: const TextStyle(
                  color: MyColor.dayWeek,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                weekdayStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                dowTextBuilder: (date, locale) {
                  return DateFormat.E(locale).format(date).substring(0, 1);
                },
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
              ),
              onDaySelected: (date, events, _) {
                setState(() {
                  _selectedDay = date;
                });
                loadActivity();
              },
            ),
          const SizedBox(height: 20),
          Expanded(child: _buildCard()),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        // color: Color(0xff30384c),
        color: MyColor.cardActivity,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  DateFormat('dd MMMM yyyy', 'it_IT')
                      .format(_selectedDay),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewActivity(selectedDate: _selectedDay)),
                    );
                  },

                  backgroundColor: MyColor.buttonNew,
                  child: const Icon(
                    Icons.add,
                    color: MyColor.daySelected,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: attivitaList.isNotEmpty
                  ? Column(
                children: attivitaList.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Attivita attivita = entry.value;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailView(
                                codiceCommessa: attivitaList[index].codiceCommessa,
                                codiceCliente: attivitaList[index].codiceCliente,
                                codiceSoggetto: attivitaList[index].codiceSoggetto,
                                tipoRapporto: attivitaList[index].tipoRapporto,
                                onSite: attivitaList[index].onSite,
                                ragioneSocialeCliente: attivitaList[index].ragioneSocialeCliente,
                                descrizioneCommessa: attivitaList[index].descrizioneCommessa,
                                giornoSelezionato: _selectedDay,
                              ),
                            ),
                          );
                        },
                        child: activityList(
                          attivita.descrizioneCommessa,
                          attivita.ragioneSocialeCliente,
                          attivita.oreLavorate.split(".")[0],
                          attivita.oreInizioAttivita,
                          attivita.oreFineAttivita,
                        ),
                      ),
                      if (index < attivitaList.length - 1)
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          height: 1,
                          width: 290,
                          color: Colors.white,
                        ),
                    ],
                  );
                }).toList(),
              )
                  : Padding(
                padding: EdgeInsets.symmetric(horizontal: 125),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.list_bullet,
                      color: Colors.white,
                      size: 80,
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nascondi la barra delle notifiche e la navbar del telefono
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setNavigationBarColor(Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MySheets',
          style: TextStyle( fontFamily: 'Gotham', color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app_sharp,
              size: 25, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Conferma uscita'),
                  content: const Text('Vuoi uscire dall\'applicazione?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        logout();
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                      },
                      child: const Text('Si'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        centerTitle: true,
        backgroundColor: MyColor.backgroudColor,
        elevation: 0,
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < -20) {
            setState(() {
              _isCalendarVisible = false;
            });
            }
        },
        child: Container(
          color: MyColor.backgroudColor,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: _buildContent()
        )
      ),
    );
  }

  Future<void> logout() async {
    // Cancella tutte le informazioni dell'utente
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Utente.codiceLogin = null;
    Utente.codicePersona = null;
    Utente.username = null;
    Utente.nome = null;
    Utente.cognome = null;
    Utente.password = null;
    Utente.azienda = null;
    Utente.token = null;
  }

  Future<void> loadActivity() async {
    final token = Utente.token;
    final response = await Api.getAttivitaByGiorno(
        DateFormat('yyyy-MM-dd').format(_selectedDay), token.toString());
    attivitaList.clear();
    setState(() {
      jsonResponse = json.decode(response.body);
      log('Attività del giorno $_selectedDay - Response: $jsonResponse');
      if (jsonResponse['attivita'] != null) {
        final attivitaListJson = jsonResponse['attivita'] as List;
        log('Lista Attività del giorno $_selectedDay: $attivitaListJson ');
        for (final attivitaJson in attivitaListJson) {
          var att = Attivita(
              attivitaJson['data'],
              attivitaJson['ragioneSocialeCliente'],
              attivitaJson['codiceCommessa'],
              attivitaJson['descrizioneCommessa'],
              attivitaJson['codiceCliente'],
              attivitaJson['tipoRapporto'],
              attivitaJson['codiceSoggetto'],
              attivitaJson['descizioneAttivita'],
              attivitaJson['oreLavorate'],
              attivitaJson['oreInizioAttivita'],
              attivitaJson['oreFineAttivita'],
              attivitaJson['onSite']);
          attivitaList.add(att);
        }
      }
    });
  }

  Future<bool> eliminaAttivita(String codiceCommessa, String codiceCliente, String tipoRapporto, String onSite) async {
    final token = Utente.token;
    String dateString = _selectedDay.toIso8601String();
    String dateOnly = dateString.substring(0, 10);
    final response = await Api.deleteTimesheet(
        dateOnly,
        codiceCommessa,
        '${Utente.codicePersona}',
        codiceCliente,
        tipoRapporto,
        onSite,
        token.toString());

    jsonResponse = json.decode(response.body);
    log('Elimina attività - Response: $jsonResponse');
    if (jsonResponse['success'] == true) {
      return true;
    }
    return false;
  }

}
