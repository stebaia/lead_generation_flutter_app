class SendBulkOfflineModel {
  String? iddatabaselocal;
  String? idmanifestazione;
  String? idzona;
  String? codice;
  String? data;

  SendBulkOfflineModel(
      {this.iddatabaselocal,
      this.idmanifestazione,
      this.idzona,
      this.codice,
      this.data});

  SendBulkOfflineModel.fromJson(Map<String, dynamic> json) {
    iddatabaselocal = json['iddatabaselocal'];
    idmanifestazione = json['idmanifestazione'];
    idzona = json['idzona'];
    codice = json['codice'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iddatabaselocal'] = this.iddatabaselocal;
    data['idmanifestazione'] = this.idmanifestazione;
    data['idzona'] = this.idzona;
    data['codice'] = this.codice;
    data['data'] = this.data;
    return data;
  }
}
