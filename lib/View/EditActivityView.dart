import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysheets_app/Altro/Api.dart';
import 'package:mysheets_app/Altro/MyColor.dart';
import 'package:mysheets_app/Model/Timesheet.dart';
import 'package:mysheets_app/Model/Utente.dart';
import 'package:mysheets_app/View/DetailActivityView.dart';
import 'package:mysheets_app/View/HomepageView.dart';

class EditActivityView extends StatefulWidget {
  final Timesheet timesheet;

  EditActivityView({
    required this.timesheet
  });

  @override
  _EditActivityViewState createState() => _EditActivityViewState(
    timesheet: timesheet,
  );
}

class _EditActivityViewState extends State<EditActivityView> {

  final Timesheet timesheet;
  String oreFrazValue = '4h';
  String onsiteValue = 'No';
  String flussoQualiValue = 'Commesse Formazione clienti';

  late Map<String, dynamic> jsonResponse;

  TimeOfDay _oraInizio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _oraFine = const TimeOfDay(hour: 10, minute: 0);

  TimeOfDay _oraInizioStra = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _oraFineStra = const TimeOfDay(hour: 0, minute: 0);

  _EditActivityViewState({required this.timesheet});

  @override
  void initState() {
    super.initState();
    formatHour();
    formatHourStra();
    setFlussoQuali();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.backgroudColor,
      appBar: AppBar(
        title: const Text(
          'Modifica attività',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
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
                                        DateFormat('dd MMMM yyyy', 'it_IT').format(DateTime.parse(timesheet.data)),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () async {
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),

                      //Cliente
                      const SizedBox(height: 10),
                      const Text(
                        'Cliente',
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
                                timesheet.nomeCliente,
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: const Icon(
                                  CupertinoIcons.person_alt_circle_fill,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                onPressed: () async {
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Commessa
                      const SizedBox(height: 10),
                      const Text(
                        'Commessa',
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
                              Expanded(
                                child: Text(
                                  timesheet.descrizioneCommessa,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  CupertinoIcons.briefcase,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  // Azione da eseguire al click del pulsante
                                },
                              ),
                            ],
                          ),
                        ),
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
                              if (['4h', '8h'].contains(newValue)) {
                                setState(() {
                                  oreFrazValue = newValue!;
                                  timesheet.oreFrazionabili = oreFrazValue;
                                });
                              }
                            },
                            underline: Container(),
                            items: <String>['4h', '8h'].map<DropdownMenuItem<String>>((String value) {
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
                            fontWeight: FontWeight.bold
                        ),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      'Ore: ' + timesheet.oreLavorate.toString(),
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
                                      formatHour(reverse: true);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: TextEditingController(text: _oraInizio.format(context),),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Inizio attività',
                                    ),
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
                                      formatHour(reverse: true);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: TextEditingController(text: _oraFine.format(context),),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Fine attività',
                                    ),
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
                            fontWeight: FontWeight.bold
                        ),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      'Ore: ' + timesheet.oreReperibilita.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ]),

                      // Ore, Inizio e Fine straordinario
                      const SizedBox(height: 20),
                      const Text(
                        'Ore straordinario',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      'Ore: ' + timesheet.oreStraordinario.toString(),
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
                                      formatHourStra(reverse: true);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: TextEditingController(text: _oraInizioStra.format(context),),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Inizio attività',
                                    ),
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
                                      formatHourStra(reverse: true);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: TextEditingController(text: _oraFineStra.format(context),),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Fine attività',
                                    ),
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ]),

                      //Onsite
                      const SizedBox(height: 10),
                      const Text(
                        'Onsite',
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
                              Expanded(
                                child: Text(
                                  timesheet.onSite,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  CupertinoIcons.location_solid,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  // Azione da eseguire al click del pulsante
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Flusso Qualità
                      const SizedBox(height: 20),
                      const Text(
                        'Flusso Qualità',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
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
                                timesheet.flussoQualita = flussoQualiValue;
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
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.all(10),
                        child:TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration.collapsed(hintText: 'Inserisci la descrizione qui...'),
                          initialValue: timesheet.descrizioneAttivita,
                          onChanged: (value) {
                            setState(() {
                              timesheet.descrizioneAttivita = value;
                            });
                          },
                        ),

                      ),

                      // Bottone Salva
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            setFlussoQuali2();
                            bool isSuccess = await updateActivity(timesheet);
                            // Mostrare finestra di dialogo a seconda del risultato dell'inserimento
                            if (isSuccess == true) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:  Text("Modifica effettuata correttamente."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          //Navigator.of(context).pop();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DetailView(
                                                    codiceCommessa: timesheet.codiceCommessa,
                                                    codiceCliente: timesheet.codiceCliente,
                                                    codiceSoggetto: timesheet.codiceSoggetto,
                                                    tipoRapporto: timesheet.tipoRapportoCliente,
                                                    onSite: timesheet.onSite,
                                                    ragioneSocialeCliente: timesheet.nomeCliente,
                                                    descrizioneCommessa: timesheet.descrizioneCommessa,
                                                    giornoSelezionato: DateTime.parse(timesheet.data)
                                                )
                                            ),
                                            ModalRoute.withName('/'),
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
                                    title: Text("Modifica fallita: " + jsonResponse["message"].substring(0, 58)),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
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
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            minimumSize: const Size(130, 50),
                          ),
                          child:
                          const Text('Salva', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  )
              ),
            ]
        ),
      ),
    );
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
                      timesheet.oreLavorate = value + 1;
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
                    setState(() {});
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
                      timesheet.oreStraordinario = value;
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
                    setState(() {});
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
                      timesheet.oreReperibilita = value;
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


  void formatHour({bool reverse = false}) {

    //Per convertire gli oggetti TimeOfDay in stringhe e assegnare i valori a timesheet.oreInizioAttivita e timesheet.oreFineAttivita, chiamo formatHour(reverse:true)
    if (!reverse) {
      int oreiniz = int.parse(timesheet.oreInizioAttivita.substring(0,2));
      int mininiz = int.parse(timesheet.oreInizioAttivita.substring(3,5));
      _oraInizio = _oraInizio.replacing(hour: oreiniz, minute: mininiz);

      int orefin  = int.parse(timesheet.oreFineAttivita.substring(0,2));
      int minfin = int.parse(timesheet.oreFineAttivita.substring(3,5));
      _oraFine = _oraFine.replacing(hour: orefin, minute: minfin);

      oreFrazValue = timesheet.oreFrazionabili!.trim();
      flussoQualiValue = timesheet.flussoQualita.trim();

    } else {
      int inizioMinuti = _oraInizio.hour * 60 + _oraInizio.minute;
      int fineMinuti = _oraFine.hour * 60 + _oraFine.minute;

      String oreInizio = "${inizioMinuti ~/ 60}".padLeft(2, '0');
      String minutiInizio = "${inizioMinuti % 60}".padLeft(2, '0');
      timesheet.oreInizioAttivita = "$oreInizio:$minutiInizio";

      String oreFine = "${fineMinuti ~/ 60}".padLeft(2, '0');
      String minutiFine = "${fineMinuti % 60}".padLeft(2, '0');
      timesheet.oreFineAttivita = "$oreFine:$minutiFine";
    }
  }

  void formatHourStra({bool reverse = false}) {
    if (!reverse) {
      if (timesheet.oreInizioStraordinario != null) {
        int oreiniz = int.parse(timesheet.oreInizioStraordinario!.substring(0, 2));
        int mininiz = int.parse(timesheet.oreInizioStraordinario!.substring(3, 5));
        _oraInizioStra = TimeOfDay(hour: oreiniz, minute: mininiz);
      }

      if (timesheet.oreFineStraordinario != null) {
        int orefin = int.parse(timesheet.oreFineStraordinario!.substring(0, 2));
        int minfin = int.parse(timesheet.oreFineStraordinario!.substring(3, 5));
        _oraFineStra = TimeOfDay(hour: orefin, minute: minfin);
      }

    } else {
      int inizioMinuti = _oraInizioStra.hour * 60 + _oraInizioStra.minute;
      int fineMinuti = _oraFineStra.hour * 60 + _oraFineStra.minute;

      if (timesheet.oreInizioStraordinario != null) {
        String oreInizio = "${inizioMinuti ~/ 60}".padLeft(2, '0');
        String minutiInizio = "${inizioMinuti % 60}".padLeft(2, '0');
        timesheet.oreInizioStraordinario = "$oreInizio:$minutiInizio";
      }

      if (timesheet.oreFineStraordinario != null) {
        String oreFine = "${fineMinuti ~/ 60}".padLeft(2, '0');
        String minutiFine = "${fineMinuti % 60}".padLeft(2, '0');
        timesheet.oreFineStraordinario = "$oreFine:$minutiFine";
      }

    }
  }

  void setFlussoQuali(){
    if(flussoQualiValue == 'COFCLI') {
      flussoQualiValue = 'Commesse Formazione clienti';
    } else if(flussoQualiValue == 'DEVCCO') {
      flussoQualiValue = 'Delivery - Collaudo e consegna';
    } else if(flussoQualiValue == 'DEVMCR') {
      flussoQualiValue = 'Delivery - Macroanalisi';
    } else if(flussoQualiValue == 'DEVPSA') {
      flussoQualiValue = 'Delivery - Presidio - Servizi annuali';
    } else if(flussoQualiValue == 'DEVSPR') {
      flussoQualiValue = 'Delivery - Sviluppo progetto';
    } else if(flussoQualiValue == 'DEVTPI') {
      flussoQualiValue = 'Delivery - Test di progetto interno';
    } else if(flussoQualiValue == 'ALTRO') {
      flussoQualiValue = 'Altro';
    } else if(flussoQualiValue == 'FORINT') {
      flussoQualiValue = 'Formazione interna';
    } else if(flussoQualiValue == 'SUPASS') {
      flussoQualiValue = 'Support - Assistenza';
    }
  }

  void setFlussoQuali2(){
    if(timesheet.flussoQualita == 'Commesse Formazione clienti') timesheet.flussoQualita = 'COFCLI';
    else if(timesheet.flussoQualita == 'Delivery - Collaudo e consegna') timesheet.flussoQualita = 'DEVCCO';
    else if(timesheet.flussoQualita == 'Delivery - Macroanalisi') timesheet.flussoQualita = 'DEVMCR';
    else if(timesheet.flussoQualita == 'Delivery - Presidio - Servizi annuali') timesheet.flussoQualita = 'DEVPSA';
    else if(timesheet.flussoQualita == 'Delivery - Sviluppo progetto') timesheet.flussoQualita = 'DEVSPR';
    else if(timesheet.flussoQualita == 'Delivery - Test di progetto interno') timesheet.flussoQualita = 'DEVTPI';
    else if(timesheet.flussoQualita == 'Altro') timesheet.flussoQualita = 'ALTRO';
    else if(timesheet.flussoQualita == 'Formazione interna') timesheet.flussoQualita = 'FORINT';
    else if(timesheet.flussoQualita == 'Support - Assistenza') timesheet.flussoQualita = 'SUPASS';
  }

  Future<bool> updateActivity(Timesheet timesheet) async {
    final token = Utente.token;
    final response = await Api.updateTimesheet(timesheet, token.toString());
    jsonResponse = json.decode(response.body);
    log('Update attività timesheet - Response: $jsonResponse');
    if (jsonResponse['success'] == true) {
      return true;
    }
    return false;
  }


}
