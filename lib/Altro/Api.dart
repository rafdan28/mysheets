import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mysheets_app/Altro/LoginRequest.dart';

import '../Model/Timesheet.dart';

class Api{
  // static String REST_API_URL = "http://10.10.0.74:8080/mysheets/api";
  // static String REST_API_URL = "http://localhost:8080/mysheets/api";
  static String REST_API_URL = "https://infinity.smsengineering.it/mysheets/api";

  static verificaToken(String token){
    return http.get(
      Uri.parse('$REST_API_URL/utente/verifica'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
    );
  }

  static getUtenteByUsername(String username){
    return http.get(
      Uri.parse('$REST_API_URL/utente/getUtenteByUsername/$username'),
    );
  }

  static login(LoginRequest loginRequest) {
    return http.post(
      Uri.parse('$REST_API_URL/utente/login'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json', // specifica il tipo di contenuto come JSON
      },
      body: jsonEncode(loginRequest.toJson()),
    );
    // return http.get(
    //   Uri.parse('${REST_API_URL}/utente/login?username=${username}&password=${password}'),
    // );
  }

  static getAttivitaByGiorno(String data, String token){
    return http.get(
      Uri.parse('$REST_API_URL/timesheet/getAttivitaByGiorno?data=$data'),
       headers: {
         HttpHeaders.authorizationHeader: 'Bearer $token'
       }
    );
  }

  static getDettaglioAttivitaByGiorno(String data, String codiceCommessa, String codicePersona, String codiceCliente, String tipoRapporto, String onSite, String token){
    return http.get(
        Uri.parse('$REST_API_URL/timesheet/getDettaglioAttivitaByGiorno?data=$data&codiceCommessa=$codiceCommessa&codicePersona=$codicePersona&codiceCliente=$codiceCliente&tipoRapporto=$tipoRapporto&onSite=$onSite'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );
  }

  static getAllClienti(String token){
    return http.get(
        Uri.parse('$REST_API_URL/cliente/getAllClienti'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );
  }

  static getCommessaByCliente(String codiceCliente, String token){
    return http.get(
        Uri.parse('$REST_API_URL/commessa/getCommessaByCliente?codiceCliente=$codiceCliente'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );
  }

  static insertTimesheet(Timesheet timesheet, String token){
    return http.post(
        Uri.parse('$REST_API_URL/timesheet/salva'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json', // specifica il tipo di contenuto come JSON
        },
      body: jsonEncode(timesheet.toJson()), // serializza l'oggetto timesheet in JSON
    );
  }

  static deleteTimesheet(String data, String codiceCommmessa, String codicePersona, String codiceCliente, String tipoRapporto, String onSite, String token){
    return http.delete(
        Uri.parse('$REST_API_URL/timesheet/elimina?data=$data&codiceCommessa=$codiceCommmessa&codicePersona=$codicePersona&codiceCliente=$codiceCliente&tipoRapporto=$tipoRapporto&onSite=$onSite'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );
  }

  static updateTimesheet(Timesheet timesheet, String token){
    return http.put(
        Uri.parse('$REST_API_URL/timesheet/aggiorna'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(timesheet.toJson()),
    );
  }

}