class Timesheet{
  String codiceCommessa;
  String descrizioneCommessa;
  String codiceSoggetto;
  String tipoRapportoCliente;
  String codiceCliente;
  String nomeCliente;
  String data; //Date data;
  String onSite;
  String flussoQualita;
  int oreLavorate;
  String oreInizioAttivita;
  String oreFineAttivita;
  int oreStraordinario;
  String? oreInizioStraordinario;
  String? oreFineStraordinario;
  int oreReperibilita;
  String? oreFrazionabili;
  String descrizioneAttivita;
  String? destinazioneSedeCliente;
  String? tipoDestinazione;
  double kmEffettivi;
  double costoTrasferta;
  double costoAlbergo;
  double costoCena;
  double costoViaggio;
  double costoParcheggio;
  double rimborsoSpese;
  String? descrizioneRimborsoSpese;
  String? ticket;
  int autoAzi;
  double rimborsoKm;
  double totaleSpese;
  int annoIntervento;
  int numeroIntervento;
  int flagRIA;
  String? dataRIA; //Date dataRIA;
  String? emailCliente;
  String? emailDipendente;
  String? emailAggiuntiva;

  Timesheet(
      this.codiceCommessa,
      this.descrizioneCommessa,
      this.codiceSoggetto,
      this.tipoRapportoCliente,
      this.codiceCliente,
      this.nomeCliente,
      this.data,
      this.onSite,
      this.flussoQualita,
      this.oreLavorate,
      this.oreInizioAttivita,
      this.oreFineAttivita,
      this.oreStraordinario,
      this.oreInizioStraordinario,
      this.oreFineStraordinario,
      this.oreReperibilita,
      this.oreFrazionabili,
      this.descrizioneAttivita,
      this.destinazioneSedeCliente,
      this.tipoDestinazione,
      this.kmEffettivi,
      this.costoTrasferta,
      this.costoAlbergo,
      this.costoCena,
      this.costoViaggio,
      this.costoParcheggio,
      this.rimborsoSpese,
      this.descrizioneRimborsoSpese,
      this.ticket,
      this.autoAzi,
      this.rimborsoKm,
      this.totaleSpese,
      this.annoIntervento,
      this.numeroIntervento,
      this.flagRIA,
      this.dataRIA,
      this.emailCliente,
      this.emailDipendente,
      this.emailAggiuntiva
  );



  Map<String, dynamic> toJson() {
    return {
      'codiceCommessa': codiceCommessa,
      'descrizioneCommessa': descrizioneCommessa,
      'codiceSoggetto': codiceSoggetto,
      'tipoRapportoCliente': tipoRapportoCliente,
      'codiceCliente': codiceCliente,
      'nomeCliente': nomeCliente,
      'data': data,
      'onSite': onSite,
      'flussoQualita': flussoQualita,
      'oreLavorate': oreLavorate,
      'oreInizioAttivita': oreInizioAttivita,
      'oreFineAttivita': oreFineAttivita,
      'oreStraordinario': oreStraordinario,
      'oreInizioStraordinario': oreInizioStraordinario,
      'oreFineStraordinario': oreFineStraordinario,
      'oreReperibilita': oreReperibilita,
      'oreFrazionabili': oreFrazionabili,
      'descrizioneAttivita': descrizioneAttivita,
      'destinazioneSedeCliente': destinazioneSedeCliente,
      'tipoDestinazione': tipoDestinazione,
      'kmEffettivi': kmEffettivi,
      'costoTrasferta': costoTrasferta,
      'costoAlbergo': costoAlbergo,
      'costoCena': costoCena,
      'costoViaggio': costoViaggio,
      'costoParcheggio': costoParcheggio,
      'rimborsoSpese': rimborsoSpese,
      'descrizioneRimborsoSpese': descrizioneRimborsoSpese,
      'ticket': ticket,
      'autoAzi': autoAzi,
      'rimborsoKm': rimborsoKm,
      'totaleSpese': totaleSpese,
      'annoIntervento': annoIntervento,
      'numeroIntervento': numeroIntervento,
      'flagRIA': flagRIA,
      'dataRIA': dataRIA,
      'emailCliente': emailCliente,
      'emailDipendente': emailDipendente,
      'emailAggiuntiva': emailAggiuntiva,
    };
  }
}