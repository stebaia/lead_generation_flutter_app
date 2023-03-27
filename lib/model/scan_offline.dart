class OfflineScan {
  final int idManifestazione;
  final String codice;
  final String idUtilizzatore;
  final String dataOra;
  final int idCorso;
  final String ckExit;

  OfflineScan(
      {required this.idManifestazione,
      required this.codice,
      required this.ckExit,
      required this.dataOra,
      required this.idCorso,
      required this.idUtilizzatore});

  factory OfflineScan.fromMap(Map<String, dynamic> json) => OfflineScan(
      idManifestazione: json['idManifestazione'],
      codice: json['codice'],
      ckExit: json['ckExit'],
      dataOra: json['dataOra'],
      idCorso: json['idCorso'],
      idUtilizzatore: json['idUtilizzatore']);

  Map<String, dynamic> toMap() {
    return {
      'idManifestazione': idManifestazione,
      'codice': codice,
      'ckExit': ckExit,
      'dataOra': dataOra,
      'idCorso': idCorso,
      'idUtilizzatore': idUtilizzatore
    };
  }
}
