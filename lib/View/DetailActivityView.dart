// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously



import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysheets_app/Altro/Api.dart';
import 'package:mysheets_app/Altro/MyColor.dart';
import 'package:mysheets_app/Altro/SideLeftRoute.dart';
import 'package:mysheets_app/Model/Timesheet.dart';
import 'package:mysheets_app/Model/Utente.dart';
import 'package:mysheets_app/View/HomepageView.dart';
import 'package:mysheets_app/View/EditActivityView.dart';

class DetailView extends StatefulWidget {
  final String codiceCommessa;
  final String codiceCliente;
  final String codiceSoggetto;
  final String tipoRapporto;
  final String onSite;
  final String ragioneSocialeCliente;
  final String descrizioneCommessa;
  final DateTime giornoSelezionato;

  const DetailView({Key? key,
      required this.codiceCommessa,
      required this.codiceCliente,
      required this.codiceSoggetto,
      required this.tipoRapporto,
      required this.onSite,
      required this.ragioneSocialeCliente,
      required this.descrizioneCommessa,
      required this.giornoSelezionato}
      ) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _DetailViewState createState() => _DetailViewState(
        codiceCommessa: codiceCommessa,
        codiceCliente: codiceCliente,
        codiceSoggetto: codiceSoggetto,
        tipoRapporto: tipoRapporto,
        onSite: onSite,
        ragioneSocialeCliente: ragioneSocialeCliente,
        descrizioneCommessa: descrizioneCommessa,
        giornoSelezionato: giornoSelezionato,
      );
}

class _DetailViewState extends State<DetailView> {
  final String codiceCommessa;
  final String codiceCliente;
  final String codiceSoggetto;
  final String tipoRapporto;
  final String onSite;
  final String ragioneSocialeCliente;
  final String descrizioneCommessa;
  final DateTime giornoSelezionato;

  late Map<String, dynamic> jsonResponse;
  late Timesheet timesheet;
  bool _isLoading = false;

  _DetailViewState({
    required this.codiceCommessa,
    required this.codiceCliente,
    required this.codiceSoggetto,
    required this.tipoRapporto,
    required this.onSite,
    required this.ragioneSocialeCliente,
    required this.descrizioneCommessa,
    required this.giornoSelezionato,
  });

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {
      // Settiamo _isLoading a true per mostrare l'indicatore di caricamento
      _isLoading = true;
    });

    timesheet = await loadActivityDetail();

    setState(() {
      // _isLoading a false per nascondere l'indicatore di caricamento
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.backgroudColor,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Dettaglio attività",
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text("del ${DateFormat('d MMMM y', 'it_IT').format(giornoSelezionato)}",
                style: TextStyle(color: Colors.grey[600], fontSize: 18),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (Route<dynamic> route) => false);
            },
          ),
          centerTitle: true,
          leadingWidth: 50.0,
          backgroundColor: MyColor.backgroudColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.person_alt_circle,
                                                  color: MyColor.dayWeek,
                                                  size: 60,
                                                ),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      timesheet.nomeCliente,
                                                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      timesheet.descrizioneCommessa,
                                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        //Flusso Qualità
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.greaterthan_circle,
                                              color: Colors.black,
                                              size: 28,
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Text(
                                                timesheet.flussoQualita,
                                                style: const TextStyle(fontSize: 18, color: Colors.black,),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                                          height: 1,
                                          width: 350,
                                          color: MyColor.dayWeek,
                                        ),

                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [

                                              // Spazio tra i due container
                                              Container(
                                                width: 120,
                                                height: 120,
                                                margin: const EdgeInsets.symmetric(vertical: 10.0),
                                                padding: const EdgeInsets.all(15.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          '${timesheet.oreFrazionabili}',
                                                          style: TextStyle(fontSize: 20, color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 50),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            'Frazionabili',
                                                            style: TextStyle(fontSize: 12, color: Colors.black),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(width: 15),
                                              Container(
                                                width: 120,
                                                height: 120,
                                                margin: const EdgeInsets.symmetric(vertical: 10.0),
                                                padding: const EdgeInsets.all(15.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          '${timesheet.oreLavorate}h',
                                                          style: TextStyle(fontSize: 20, color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 50),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            '${timesheet.oreInizioAttivita} > ${timesheet.oreFineAttivita}',
                                                            style: TextStyle(fontSize: 12, color: Colors.black),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(width: 15),
                                              Visibility(
                                                visible: timesheet.oreReperibilita != 0,
                                                child: Container(
                                                  width: 120,
                                                  height: 120,// Imposta la larghezza desiderata per il box
                                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                                  padding: const EdgeInsets.all(15.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            '${timesheet.oreReperibilita}h',
                                                            style: TextStyle(fontSize: 20, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 50),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              'Reperibilità',
                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 15),
                                              Visibility(
                                                visible: timesheet.oreStraordinario != 0,
                                                child: Container(
                                                  width: 120,
                                                  height: 120,
                                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                                  padding: const EdgeInsets.all(15.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            '${timesheet.oreStraordinario}h',
                                                            style: TextStyle(fontSize: 20, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 50),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              '${timesheet.oreInizioStraordinario} > ${timesheet.oreFineStraordinario}',
                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                                          height: 1,
                                          width: 350,
                                          color: MyColor.dayWeek,
                                        ),

                                        const SizedBox(height: 10),

                                        Container(
                                          padding: const EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Column(
                                            children: [
                                              //OnSite
                                              Row(
                                                children: const [
                                                  Text(
                                                    'OnSite',
                                                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    CupertinoIcons.location_solid,
                                                    color: Colors.black,
                                                    size: 28,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      timesheet.onSite,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 10),
                                              //Descrizione
                                              Row(
                                                children: const [
                                                  SizedBox(height: 10),
                                                  Text('Descrizione',
                                                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    CupertinoIcons.doc_text_fill,
                                                    color: Colors.black,
                                                    size: 28,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      timesheet.descrizioneAttivita,
                                                      style: const TextStyle(fontSize: 18, color: Colors.black),
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

                                  // Bottone Modifica
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: MyColor.button,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                          minimumSize: const Size(130, 50),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            SlideLeftRoute(page: EditActivityView(timesheet: timesheet)),
                                          );
                                        },
                                        child: const Text('Modifica', style: TextStyle(fontSize: 20)),
                                      ),


                                      //Bottone Elimina
                                      const SizedBox(width: 30),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: MyColor.dayWeek,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 15),
                                          minimumSize: const Size(130, 50),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Eliminare l'attività?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      bool isSuccess = await eliminaAttivita(codiceCommessa, codiceCliente, tipoRapporto, onSite);
                                                      if (isSuccess == true) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text("${jsonResponse["message"]}"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                        Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (Route<dynamic> route) => false);
                                                                      },
                                                                  child:
                                                                      const Text("Ok"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Cancellazione fallita: ${jsonResponse["message"].substring(0, 58)}"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child:
                                                                      const Text("Ok"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: const Text("Si"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Elimina',
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  Future<Timesheet> loadActivityDetail() async {
    final token = Utente.token.toString();
    // final codicePersona = Utente.codicePersona.toString();
    // if(codicePersona == "000000000000002"){
    //
    // }
    final response = await Api.getDettaglioAttivitaByGiorno(
        giornoSelezionato.toIso8601String().substring(0, 10),
        codiceCommessa,
        codiceSoggetto,
        codiceCliente,
        tipoRapporto,
        onSite,
        token);
    // ignore: prefer_interpolation_to_compose_strings
    log('Attività del giorno ${giornoSelezionato.toIso8601String().substring(0, 10)} - Body 2: ' +
        response.body);
    late List<dynamic> jsonResponse2 = json.decode(response.body);
    String inizioStra = "00:00";
    String fineStra = "00:00";
    if(jsonResponse2[0]['oreInizioStraordinario'] != null){
      inizioStra = jsonResponse2[0]['oreInizioStraordinario'];
    }
    if(jsonResponse2[0]['oreFineStraordinario'] != null){
      fineStra = jsonResponse2[0]['oreFineStraordinario'];
    }
    Timesheet timesheet = Timesheet(
        jsonResponse2[0]['codiceCommessa'],
        jsonResponse2[0]['descrizioneCommessa'],
        jsonResponse2[0]['codiceSoggetto'],
        jsonResponse2[0]['tipoRapportoCliente'],
        jsonResponse2[0]['codiceCliente'],
        jsonResponse2[0]['nomeCliente'],
        jsonResponse2[0]['data'],
        jsonResponse2[0]['onSite'],
        jsonResponse2[0]['flussoQualita'],
        jsonResponse2[0]['oreLavorate'],
        jsonResponse2[0]['oreInizioAttivita'],
        jsonResponse2[0]['oreFineAttivita'],
        jsonResponse2[0]['oreStraordinario'],
        jsonResponse2[0]['oreInizioStraordinario'] as String?,
        jsonResponse2[0]['oreFineStraordinario'] as String?,
        jsonResponse2[0]['oreReperibilita'],
        jsonResponse2[0]['oreFrazionabili'] as String?,
        jsonResponse2[0]['descrizioneAttivita'],
        jsonResponse2[0]['destinazioneSedeCliente'] as String?,
        jsonResponse2[0]['tipoDestinazione'] as String?,
        jsonResponse2[0]['kmEffettivi'],
        jsonResponse2[0]['costoTrasferta'],
        jsonResponse2[0]['costoAlbergo'],
        jsonResponse2[0]['costoCena'],
        jsonResponse2[0]['costoViaggio'],
        jsonResponse2[0]['costoParcheggio'],
        jsonResponse2[0]['rimborsoSpese'],
        jsonResponse2[0]['descrizioneRimborsoSpese'] as String?,
        jsonResponse2[0]['ticket'] as String?,
        jsonResponse2[0]['autoAzi'],
        jsonResponse2[0]['rimborsoKm'],
        jsonResponse2[0]['totaleSpese'],
        jsonResponse2[0]['annoIntervento'],
        jsonResponse2[0]['numeroIntervento'],
        jsonResponse2[0]['flagRIA'],
        jsonResponse2[0]['dataRIA'] as String?,
        jsonResponse2[0]['emailCliente'] as String?,
        jsonResponse2[0]['emailDipendente'] as String?,
        jsonResponse2[0]['emailAggiuntiva'] as String? );
        setFlussoQuali(timesheet);
        // setHour(timesheet);
    return timesheet;

  }

  // void setHour(Timesheet timesheet) {
  //   if (timesheet.oreFrazionabili == null || timesheet.oreFrazionabili.trim() == "null" || timesheet.oreFrazionabili.trim().isEmpty) {
  //     timesheet.oreFrazionabili = "8h";
  //   }
  //   if (timesheet.oreInizioStraordinario == null || timesheet.oreInizioStraordinario.trim() == "null" || timesheet.oreInizioStraordinario.trim().isEmpty) {
  //     timesheet.oreInizioStraordinario = "00:00";
  //   }
  //   if (timesheet.oreFineStraordinario == null || timesheet.oreFineStraordinario.trim() == "null" || timesheet.oreFineStraordinario.trim().isEmpty) {
  //     timesheet.oreFineStraordinario = "00:00";
  //   }
  // }

  void setFlussoQuali(Timesheet timesheet){
    if(timesheet.flussoQualita == 'COFCLI') {
      timesheet.flussoQualita = 'Commesse Formazione clienti';
    } else if(timesheet.flussoQualita == 'DEVCCO') {
      timesheet.flussoQualita = 'Delivery - Collaudo e consegna';
    } else if(timesheet.flussoQualita == 'DEVMCR') {
      timesheet.flussoQualita = 'Delivery - Macroanalisi';
    } else if(timesheet.flussoQualita == 'DEVPSA') {
      timesheet.flussoQualita = 'Delivery - Presidio - Servizi annuali';
    } else if(timesheet.flussoQualita == 'DEVSPR') {
      timesheet.flussoQualita = 'Delivery - Sviluppo progetto';
    } else if(timesheet.flussoQualita == 'DEVTPI') {
      timesheet.flussoQualita = 'Delivery - Test di progetto interno';
    } else if(timesheet.flussoQualita == 'ALTRO') {
      timesheet.flussoQualita = 'Altro';
    } else if(timesheet.flussoQualita == 'FORINT') {
      timesheet.flussoQualita = 'Formazione interna';
    } else if(timesheet.flussoQualita == 'SUPASS') {
      timesheet.flussoQualita = 'Support - Assistenza';
    }
  }

  Future<bool> eliminaAttivita(String codiceCommessa, String codiceCliente, String tipoRapporto, String onSite) async {
    final token = Utente.token;
    final response = await Api.deleteTimesheet(
        giornoSelezionato.toIso8601String().substring(0, 10),
        codiceCommessa,
        '${Utente.codicePersona}',
        codiceCliente,
        tipoRapporto,
        onSite,
        token.toString());
    jsonResponse = json.decode(response.body);
    log('Elimina attività: $jsonResponse');
    if (jsonResponse['success'] == true) {
      return true;
    }
    return false;
  }

}
