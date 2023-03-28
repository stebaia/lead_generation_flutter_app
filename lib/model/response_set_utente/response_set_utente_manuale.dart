class AutogenratedSetUtenteAppManuale {
  SoapEnvelope? soapEnvelope;

  AutogenratedSetUtenteAppManuale({this.soapEnvelope});

  AutogenratedSetUtenteAppManuale.fromJson(Map<String, dynamic> json) {
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
  SetutenteappmanualeResponse? setutenteappmanualeResponse;

  SoapBody({this.setutenteappmanualeResponse});

  SoapBody.fromJson(Map<String, dynamic> json) {
    setutenteappmanualeResponse = json['SetutenteappmanualeResponse'] != null
        ? new SetutenteappmanualeResponse.fromJson(
            json['SetutenteappmanualeResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.setutenteappmanualeResponse != null) {
      data['SetutenteappmanualeResponse'] =
          this.setutenteappmanualeResponse!.toJson();
    }
    return data;
  }
}

class SetutenteappmanualeResponse {
  String? setutenteappmanualeResult;

  SetutenteappmanualeResponse({this.setutenteappmanualeResult});

  SetutenteappmanualeResponse.fromJson(Map<String, dynamic> json) {
    setutenteappmanualeResult = json['SetutenteappmanualeResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SetutenteappmanualeResult'] = this.setutenteappmanualeResult;
    return data;
  }
}