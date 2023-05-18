import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysheets_app/Altro/Api.dart';
import 'package:mysheets_app/Altro/MyColor.dart';
import 'package:mysheets_app/Altro/SideLeftRoute.dart';
import 'package:mysheets_app/Model/Cliente.dart';
import 'package:mysheets_app/Model/Commessa.dart';
import 'package:mysheets_app/Model/Timesheet.dart';
import 'package:mysheets_app/Model/Utente.dart';
import 'package:mysheets_app/View/DetailActivityView.dart';
import 'package:mysheets_app/View/HomepageView.dart';

class NewActivity extends StatefulWidget {
  late DateTime selectedDate;

  NewActivity({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<NewActivity> createState() => _NewActivityState();
}

class _NewActivityState extends State<NewActivity> {
  late Map<String, dynamic> jsonResponse;

  String selectedCliente = '';
  String selectedCodiceCliente = '';
  List<Cliente> _clienti = [];

  String selectedCommessa = '';
  String selectedCodiceCommessa = '';
  List<Commessa> _commessa = [];

  String onsiteValue = 'No';
  String oreFrazValue = '4h';
  String flussoQualiValue = 'Commesse Formazione clienti';
  String descrizioneValue = '';

  int _ore = 1;
  TimeOfDay _oraInizio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _oraFine = const TimeOfDay(hour: 10, minute: 0);

  int _oreStra = 0;
  TimeOfDay _oraInizioStra = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _oraFineStra = const TimeOfDay(hour: 0, minute: 0);

  int _oreRep = 0;

  final oreAttivitaController = TextEditingController(text: '1');
  final oreStraordinarioController = TextEditingController(text: '0');
  final oreInizioStraordinarioController = TextEditingController(text: '00:00');
  final oreFineStraordinarioController = TextEditingController(text: '00:00');

  @override
  void initState() {
    super.initState();
    getClienti().then((value) {
      setState(() {
        _clienti = value;
        selectedCliente = _clienti.isNotEmpty ? _clienti[0].ragioneSociale : '';
        selectedCodiceCliente = _clienti.isNotEmpty ? _clienti[0].codice : '';
        getCommessa(selectedCodiceCliente).then((value) {
          setState(() {
            _commessa = value;
            selectedCommessa =
                _commessa.isNotEmpty ? _commessa[0].descrizione : '';
            selectedCodiceCommessa =
                _commessa.isNotEmpty ? _commessa[0].codice : '';
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.backgroudColor,
      appBar: AppBar(
        title: const Text(
          'Aggiungi attività',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (Route<dynamic> route) => false,);
          },
        ),
        centerTitle: true,
        backgroundColor: MyColor.backgroudColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Data
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data selezionata',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd MMMM yyyy', 'it_IT')
                                    .format(widget.selectedDate),
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: widget.selectedDate,
                                    // utilizza la data passata come parametro
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      // aggiorna la data passata con quella selezionata
                                      widget.selectedDate = selectedDate;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),

                  // Cliente
                  const SizedBox(height: 10),
                  const Text(
                    'Cliente',
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Cliente>>(
                    future: getClienti(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final clienti = snapshot.data!;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCliente,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Roboto'),
                              onChanged: (String? newValue) {
                                final clienteSelezionato = clienti.firstWhere((cliente) => cliente.ragioneSociale == newValue);
                                setState(() {
                                  selectedCodiceCliente = clienteSelezionato.codice;
                                  selectedCliente = clienteSelezionato.ragioneSociale;
                                  getCommessa(selectedCodiceCliente);
                                  // selectedCommessa = null; // Aggiunto per resettare la commessa selezionata
                                });
                              },
                              // Rimuove la linea inferiore
                              underline: Container(),
                              items: clienti.map<DropdownMenuItem<String>>(
                                (cliente) {
                                  return DropdownMenuItem<String>(
                                    value: cliente.ragioneSociale,
                                    child: Text(
                                      cliente.ragioneSociale,
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Caricamento clienti fallito');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),

                  // Commessa
                  const SizedBox(height: 20),
                  const Text(
                    'Commessa',
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Commessa>>(
                    future: getCommessa(selectedCodiceCliente),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final commesse = snapshot.data!;
                        if (commesse.isNotEmpty) {
                          if (selectedCommessa == null) {
                            selectedCodiceCommessa = commesse[0].codice;
                            selectedCommessa = commesse[0].descrizione;
                          } else {
                            final selectedCommessaExists = commesse.any((commessa) => commessa.descrizione == selectedCommessa,
                            );
                            if (!selectedCommessaExists) {
                              selectedCodiceCommessa = commesse[0].codice;
                              selectedCommessa = commesse[0].descrizione;
                            }
                          }
                        }
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCommessa,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15
                              ),
                              onChanged: (String? newValue) {
                                final commessaSelezionata = commesse.firstWhere((commessa) => commessa.descrizione == newValue,);
                                setState(() {
                                  selectedCodiceCommessa = commessaSelezionata.codice;
                                  selectedCommessa = commessaSelezionata.descrizione;
                                });
                                log(selectedCodiceCommessa);
                              },
                              underline: Container(),
                              items: commesse.map<DropdownMenuItem<String>>(
                                (commessa) {
                                  return DropdownMenuItem<String>(
                                    value: commessa.descrizione,
                                    child: Text(
                                      '${commessa.codice} - ${commessa.descrizione}',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Caricamento commesse fallito');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),

                  //Ore frazionabili
                  const SizedBox(height: 20),
                  const Text(
                    'Ore frazionabili',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DropdownButton<String>(
                        value: oreFrazValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            oreFrazValue = newValue!;
                          });
                        },
                        underline: Container(),
                        items: <String>['4h', '8h']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Ore, Inizio e Fine attività
                  const SizedBox(height: 20),
                  const Text(
                    'Ore lavorate',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showPicker(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                Text(
                                  'Ore: $_ore',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: GestureDetector(
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: _oraInizio,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _oraInizio = pickedTime;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: TextEditingController(
                                  text: _oraInizio.format(context),
                                ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Inizio attività',
                                ),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: GestureDetector(
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: _oraFine,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _oraFine = pickedTime;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: TextEditingController(
                                  text: _oraFine.format(context),
                                ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Fine attività',
                                ),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),

                  // Ore reperibilità
                  const SizedBox(height: 20),
                  const Text(
                    'Ore reperibilità',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showPickerRep(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                Text(
                                  'Ore: $_oreRep',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ]),

                  // Ore, Inizio e Fine attività straordinario
                  const SizedBox(height: 20),
                  const Text(
                    'Ore straordinario',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showPickerStra(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                Text(
                                  'Ore: $_oreStra',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: GestureDetector(
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: _oraInizioStra,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _oraInizioStra = pickedTime;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: TextEditingController(
                                    text: _oraInizioStra.format(context)),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Inizio attività',
                                ),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: GestureDetector(
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: _oraFineStra,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _oraFineStra = pickedTime;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: TextEditingController(
                                    text: _oraFineStra.format(context)),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Fine attività',
                                ),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),

                  // Onsite
                  const SizedBox(height: 20),
                  const Text(
                    'OnSite',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: DropdownButton<String>(
                            value: onsiteValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                onsiteValue = newValue!;
                              });
                            },
                            underline: Container(),
                            items: <String>['No', 'Si']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Flusso Qualità
                  const SizedBox(height: 20),
                  const Text(
                    'Flusso Qualità',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DropdownButton<String>(
                        value: flussoQualiValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            flussoQualiValue = newValue!;
                          });
                        },
                        underline: Container(),
                        items: <String>[
                          'Commesse Formazione clienti',
                          'Delivery - Collaudo e consegna',
                          'Delivery - Macroanalisi',
                          'Delivery - Presidio - Servizi annuali',
                          'Delivery - Sviluppo progetto',
                          'Delivery - Test di progetto interno',
                          'Altro',
                          'Formazione interna',
                          'Support - Assistenza'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Descrizione
                  const SizedBox(height: 20),
                  const Text(
                    'Descrizione',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Inserisci la descrizione qui...'),
                      onChanged: (value) {
                        setState(() {
                          descrizioneValue = value;
                        });
                      },
                    ),
                  ),

                  // Bottone Salva
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        String dateString =
                            widget.selectedDate.toIso8601String();
                        String dateOnly = dateString.substring(0, 10);
                        // log("Salva commessa:" +
                        //     "\n Codice Commessa: ${selectedCodiceCommessa}" +
                        //     "\n Codice Persona: ${Utente.codicePersona}" +
                        //     "\n Codice Cliente : ${selectedCodiceCliente}" +
                        //     "\n Data: ${dateOnly}" +
                        //     "\n OnSite: ${onsiteValue}" +
                        //     "\n FlussoQualità: ${flussoQualiValue}" +
                        //     "\n Ore: ${_ore}" +
                        //     "\n Ore Iniz Att: ${_oraInizio.format(context)}" +
                        //     "\n Ore Fin Att: ${_oraFine.format(context)}" +
                        //     "\n Ore Stra: ${int.parse(oreStraordinarioController.text)}" +
                        //     "\n Ore Iniz Stra: ${oreInizioStraordinarioController.text}" +
                        //     "\n Ore Fin Stra: ${oreFineStraordinarioController.text}" +
                        //     "\n Ore Frazionabili: ${oreFrazValue}" +
                        //     "\n Descrizione: ${descrizioneValue}"
                        // );

                        setFlussoQuali();
                        Timesheet timesheet = Timesheet(
                            '$selectedCodiceCommessa',
                            '',
                            '${Utente.codicePersona}',
                            'CLI',
                            selectedCodiceCliente,
                            '',
                            dateOnly,
                            onsiteValue,
                            flussoQualiValue,
                            _ore,
                            _oraInizio.format(context),
                            _oraFine.format(context),
                            _oreStra,
                            _oraInizioStra.format(context),
                            _oraFineStra.format(context),
                            _oreRep,
                            oreFrazValue,
                            descrizioneValue,
                            '',
                            '',
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            '',
                            '',
                            0,
                            0,
                            0,
                            DateTime.now().year,
                            1,
                            0,
                            '',
                            '',
                            '',
                            '');

                        bool isSuccess = await insertActivity(timesheet);

                        // Mostrare finestra di dialogo a seconda del risultato dell'inserimento
                        if (isSuccess == true) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "Inserimento andato a buon fine"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailView(codiceCommessa: timesheet.codiceCommessa, codiceCliente: timesheet.codiceCliente, codiceSoggetto: timesheet.codiceSoggetto, tipoRapporto: timesheet.tipoRapportoCliente, onSite: timesheet.onSite, ragioneSocialeCliente: timesheet.nomeCliente, descrizioneCommessa: timesheet.descrizioneCommessa, giornoSelezionato: widget.selectedDate)),
                                      );
                                    },
                                    child: const Text("Ok"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Inserimento fallito."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      log(jsonResponse['message']);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Ok"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        minimumSize: const Size(130, 50),
                      ),
                      child:
                          const Text('Salva', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Cliente>> getClienti() async {
    final token = Utente.token;
    final response = await Api.getAllClienti(token.toString());
    jsonResponse = json.decode(response.body);
    log('Clienti - Response: $jsonResponse');
    if (jsonResponse['status'] == 200) {
      if (jsonResponse['cliente'] != null) {
        final clienteListJson = jsonResponse['cliente'] as List;
        log('Lista Clienti: $clienteListJson');
        List<Cliente> clienti = [];
        for (final clienteJson in clienteListJson) {
          var cli =
              Cliente(clienteJson['codice'], clienteJson['ragioneSociale']);
          clienti.add(cli);
        }
        return clienti;
      } else {
        throw Exception('Caricamenti clienti fallito');
      }
    } else {
      throw Exception('Caricamenti clienti fallito');
    }
  }

  Future<List<Commessa>> getCommessa(String codiceCliente) async {
    final token = Utente.token;
    final response =
        await Api.getCommessaByCliente(codiceCliente, token.toString());
    jsonResponse = json.decode(response.body);
    log('Commessa - Response: $jsonResponse');
    if (jsonResponse['status'] == 200) {
      if (jsonResponse['commessa'] != null) {
        final commessaListJson = jsonResponse['commessa'] as List;
        log('Lista commesse: $commessaListJson');
        List<Commessa> commessa = [];
        for (final commessaJson in commessaListJson) {
          var comm =
              Commessa(commessaJson['codice'], commessaJson['descrizione']);
          commessa.add(comm);
        }
        return commessa;
      } else {
        throw Exception('Caricamento commesse fallito');
      }
    } else {
      throw Exception('Caricamento commesse fallito');
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 50,
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      _ore = value + 1;
                    });
                  },
                  children: [
                    for (int i = 1; i <= 24; i++)
                      Text(
                        i.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showPickerStra(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 50,
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      _oreStra = value;
                    });
                  },
                  children: [
                    for (int i = 0; i <= 24; i++)
                      Text(
                        i.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showPickerRep(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 50,
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      _oreRep = value;
                    });
                  },
                  children: [
                    for (int i = 0; i <= 24; i++)
                      Text(
                        i.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> insertActivity(Timesheet timesheet) async {
    final token = Utente.token;
    final response = await Api.insertTimesheet(timesheet, token.toString());
    jsonResponse = json.decode(response.body);
    log('Insert attività timesheet - Response: $jsonResponse');
    if (jsonResponse['success'] == true) {
      return true;
    }
    return false;
  }

  void setFlussoQuali() {
    if (flussoQualiValue == 'Commesse Formazione clienti')
      flussoQualiValue = 'COFCLI';
    else if (flussoQualiValue == 'Delivery - Collaudo e consegna')
      flussoQualiValue = 'DEVCCO';
    else if (flussoQualiValue == 'Delivery - Macroanalisi')
      flussoQualiValue = 'DEVMCR';
    else if (flussoQualiValue == 'Delivery - Presidio - Servizi annuali')
      flussoQualiValue = 'DEVPSA';
    else if (flussoQualiValue == 'Delivery - Sviluppo progetto')
      flussoQualiValue = 'DEVSPR';
    else if (flussoQualiValue == 'Delivery - Test di progetto interno')
      flussoQualiValue = 'DEVTPI';
    else if (flussoQualiValue == 'Altro')
      flussoQualiValue = 'ALTRO';
    else if (flussoQualiValue == 'Formazione interna')
      flussoQualiValue = 'FORINT';
    else if (flussoQualiValue == 'Support - Assistenza')
      flussoQualiValue = 'SUPASS';
  }
}
