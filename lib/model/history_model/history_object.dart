class AutogeneratedHistoryScanModel {
  SoapEnvelope? soapEnvelope;

  AutogeneratedHistoryScanModel({this.soapEnvelope});

  AutogeneratedHistoryScanModel.fromJson(Map<String, dynamic> json) {
    soapEnvelope = json['soap:Envelope'] != null
        ? new SoapEnvelope.fromJson(json['soap:Envelope'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.soapEnvelope != null) {
      data['soap:Envelope'] = this.soapEnvelope!.toJson();
    }
    return data;
  }
}

class SoapEnvelope {
  SoapBody? soapBody;

  SoapEnvelope({this.soapBody});

  SoapEnvelope.fromJson(Map<String, dynamic> json) {
    soapBody = json['soap:Body'] != null
        ? new SoapBody.fromJson(json['soap:Body'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.soapBody != null) {
      data['soap:Body'] = this.soapBody!.toJson();
    }
    return data;
  }
}

class SoapBody {
  HistoryResponse? historyResponse;

  SoapBody({this.historyResponse});

  SoapBody.fromJson(Map<String, dynamic> json) {
    historyResponse = json['HistoryResponse'] != null
        ? new HistoryResponse.fromJson(json['HistoryResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.historyResponse != null) {
      data['HistoryResponse'] = this.historyResponse!.toJson();
    }
    return data;
  }
}

class HistoryResponse {
  HistoryResult? historyResult;

  HistoryResponse({this.historyResult});

  HistoryResponse.fromJson(Map<String, dynamic> json) {
    historyResult = json['HistoryResult'] != null
        ? new HistoryResult.fromJson(json['HistoryResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.historyResult != null) {
      data['HistoryResult'] = this.historyResult!.toJson();
    }
    return data;
  }
}

class HistoryResult {
  List<Valori3Stringhe>? valori3Stringhe;

  HistoryResult({this.valori3Stringhe});

  HistoryResult.fromJson(Map<String, dynamic> json) {
    if (json['Valori3Stringhe'] != null) {
      valori3Stringhe = <Valori3Stringhe>[];
      if(json['Valori3Stringhe'] is List){
        json['Valori3Stringhe'].forEach((v) {
        valori3Stringhe!.add(new Valori3Stringhe.fromJson(v));
      });
      }else {
        valori3Stringhe!.add(Valori3Stringhe.fromJson(json['Valori3Stringhe']));
      }
     
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.valori3Stringhe != null) {
      data['Valori3Stringhe'] =
          this.valori3Stringhe!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Valori3Stringhe {
  String? check;
  String? data;
  String? description;
  String? gate;

  Valori3Stringhe({this.check, this.data, this.description, this.gate});

  Valori3Stringhe.fromJson(Map<String, dynamic> json) {
    check = json['Check'];
    data = json['Data'];
    description = json['Description'];
    gate = json['Gate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Check'] = this.check;
    data['Data'] = this.data;
    data['Description'] = this.description;
    data['Gate'] = this.gate;
    return data;
  }
}
