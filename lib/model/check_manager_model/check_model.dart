class AutogeneratedCheckMangerModel {
  SoapEnvelope? soapEnvelope;

  AutogeneratedCheckMangerModel({this.soapEnvelope});

  AutogeneratedCheckMangerModel.fromJson(Map<String, dynamic> json) {
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
  CheckManagerResponse? checkManagerResponse;

  SoapBody({this.checkManagerResponse});

  SoapBody.fromJson(Map<String, dynamic> json) {
    checkManagerResponse = json['CheckManagerResponse'] != null
        ? new CheckManagerResponse.fromJson(json['CheckManagerResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.checkManagerResponse != null) {
      data['CheckManagerResponse'] = this.checkManagerResponse!.toJson();
    }
    return data;
  }
}

class CheckManagerResponse {
  CheckManagerResult? checkManagerResult;

  CheckManagerResponse({this.checkManagerResult});

  CheckManagerResponse.fromJson(Map<String, dynamic> json) {
    checkManagerResult = json['CheckManagerResult'] != null
        ? new CheckManagerResult.fromJson(json['CheckManagerResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.checkManagerResult != null) {
      data['CheckManagerResult'] = this.checkManagerResult!.toJson();
    }
    return data;
  }
}

class CheckManagerResult {
  String? value;
  String? description;
  String? count;

  CheckManagerResult({this.value, this.description, this.count});

  CheckManagerResult.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    description = json['Description'];
    count = json['Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Description'] = this.description;
    data['Count'] = this.count;
    return data;
  }
}