import 'dart:convert';
import 'package:xml/xml.dart';

class ExpoisitorMapper {
  String? idextra;
  String? idparent;
  String? idmanifestazione;
  String? admin;
  String? titolidisponibili;
  String? nome;
  String? cognome;
  String? ragionesociale;
  String? email;
  String? cap;
  String? telefono;
  String? note;
  String? siglanazione;
  String? siglaprovincia;
  String? idtipologia;
  String? codice20;
  String? valore;
  String? foto1;
  String? foto2;
  String? foto3;
  String? privacyCommerciale;

  ExpoisitorMapper(
      {this.idextra,
      this.idparent,
      this.idmanifestazione,
      this.admin,
      this.titolidisponibili,
      this.nome,
      this.cognome,
      this.ragionesociale,
      this.email,
      this.cap,
      this.telefono,
      this.note,
      this.siglanazione,
      this.siglaprovincia,
      this.idtipologia,
      this.codice20,
      this.valore,
      this.foto1,
      this.foto2,
      this.foto3,
      this.privacyCommerciale});

  

  ExpoisitorMapper.fromJson(Map<String, dynamic> json) {
    idextra = json['Idextra'];
    idparent = json['Idparent'];
    idmanifestazione = json['Idmanifestazione'];
    admin = json['Admin'];
    titolidisponibili = json['Titolidisponibili'];
    nome = json['Nome'] == "NULL" ? "" : json['Nome'];
    cognome = json['Cognome'] == "NULL" ? "" : json['Cognome'];
    ragionesociale = json['Ragionesociale'] == "NULL" ? "" : json['Ragionesociale'];
    email = json['Email'] == "NULL" ? "" : json['Email'];
    cap = json['Cap'] == "NULL" ? "" : json['Cap'];
    telefono = json['Telefono']== "NULL" ? "" : json['Telefono'];
    note = json['Note']== "NULL" ? "" : json['Note'];
    siglanazione = json['Siglanazione'];
    siglaprovincia = json['Siglaprovincia'];
    idtipologia = json['Idtipologia'];
    codice20 = json['Codice20'];
    valore = json['valore'];
    foto1 = json['foto1'];
    foto2 = json['foto2'];
    foto3 = json['foto3'];
    privacyCommerciale = json['privacyCommerciale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Idextra'] = this.idextra;
    data['Idparent'] = this.idparent;
    data['Idmanifestazione'] = this.idmanifestazione;
    data['Admin'] = this.admin;
    data['Titolidisponibili'] = this.titolidisponibili;
    data['Nome'] = this.nome;
    data['Cognome'] = this.cognome;
    data['Ragionesociale'] = this.ragionesociale;
    data['Email'] = this.email;
    data['Cap'] = this.cap;
    data['Telefono'] = this.telefono;
    data['Note'] = this.note;
    data['Siglanazione'] = this.siglanazione;
    data['Siglaprovincia'] = this.siglaprovincia;
    data['Idtipologia'] = this.idtipologia;
    data['Codice20'] = this.codice20;
    data['valore'] = this.valore;
    data['foto1'] = this.foto1;
    data['foto2'] = this.foto2;
    data['foto3'] = this.foto3;
    data['privacyCommerciale'] = this.privacyCommerciale;
    return data;
  }
}
