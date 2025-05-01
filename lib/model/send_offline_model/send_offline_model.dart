class SendOffileResponse {
  SoapEnvelope? soapEnvelope;

  SendOffileResponse({this.soapEnvelope});

  SendOffileResponse.fromJson(Map<String, dynamic> json) {
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
  SendOfflineResponse? sendOfflineResponse;

  SoapBody({this.sendOfflineResponse});

  SoapBody.fromJson(Map<String, dynamic> json) {
    sendOfflineResponse = json['SendOfflineResponse'] != null
        ? new SendOfflineResponse.fromJson(json['SendOfflineResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sendOfflineResponse != null) {
      data['SendOfflineResponse'] = this.sendOfflineResponse!.toJson();
    }
    return data;
  }
}

class SendOfflineResponse {
  String? sendOfflineResult;

  SendOfflineResponse({this.sendOfflineResult});

  SendOfflineResponse.fromJson(Map<String, dynamic> json) {
    sendOfflineResult = json['SendOfflineResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SendOfflineResult'] = this.sendOfflineResult;
    return data;
  }
}
