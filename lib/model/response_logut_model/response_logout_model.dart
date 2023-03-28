class AutogeneratedLogout {
  SoapEnvelope? soapEnvelope;

  AutogeneratedLogout({this.soapEnvelope});

  AutogeneratedLogout.fromJson(Map<String, dynamic> json) {
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
  LogoutUtenteResponse? logoutUtenteResponse;

  SoapBody({this.logoutUtenteResponse});

  SoapBody.fromJson(Map<String, dynamic> json) {
    logoutUtenteResponse = json['LogoutUtenteResponse'] != null
        ? new LogoutUtenteResponse.fromJson(json['LogoutUtenteResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.logoutUtenteResponse != null) {
      data['LogoutUtenteResponse'] = this.logoutUtenteResponse!.toJson();
    }
    return data;
  }
}

class LogoutUtenteResponse {
  String? logoutUtenteResult;

  LogoutUtenteResponse({this.logoutUtenteResult});

  LogoutUtenteResponse.fromJson(Map<String, dynamic> json) {
    logoutUtenteResult = json['LogoutUtenteResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LogoutUtenteResult'] = this.logoutUtenteResult;
    return data;
  }
}