import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:lead_generation_flutter_app/model/expositor.dart';
import 'package:lead_generation_flutter_app/model/expositor_mapper/expositor_mapper.dart';
import 'package:lead_generation_flutter_app/model/expositor_model/expositor_model.dart';
import 'package:lead_generation_flutter_app/network/vivaticket_api.dart';
import 'package:lead_generation_flutter_app/utils/envirorment.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

class GetUsersExtraService {
  final myTransformer = Xml2Json();

  Future<List<ExpoisitorMapper>> requestUsersExtra(
      int idUtente, Envirorment envirorment) async {
    var envelope = '''
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <GetUsersExtra xmlns="http://tempuri.org/">            
            <idutilizzatore>$idUtente</idutilizzatore>
          </GetUsersExtra>
        </soap12:Body>
      </soap12:Envelope>
    ''';

    http.Response response = await http.post(
        Uri.parse(VivaticketApi.REQUEST_GET_USERS_EXTRA(envirorment)),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          //"SOAPAction": "http://tempuri.org/GetAllCity",
          //"Host": "www.i2isoftwares.com"
          "Accept": "text/xml"
        },
        body: envelope);

    var rawXmlResponse = response.body;

// Use the xml package's 'parse' method to parse the response.
    XmlDocument customParseXml = XmlDocument.parse(rawXmlResponse);
    myTransformer.parse(rawXmlResponse);
    var jsonResponse = myTransformer.toParker();
    Map<String, dynamic> responseJson = json.decode(jsonResponse);
    AutogeneratedExpositor corseResponse =
        AutogeneratedExpositor.fromJson(responseJson);
    //LoginResult result = LoginResult.fromJson(responseJsonjj["soap:Envelope"]["soap:Body"]["LoginUtenteResponse"]["LoginUtenteResult"]);
    print("DATAResult=" + response.body);
    GetUsersExtraResult getCorsiResult = corseResponse
        .soapEnvelope!.soapBody!.getUsersExtraResponse!.getUsersExtraResult!;
    List<ExpoisitorMapper> courseList = [];
    int index = 0;

    getCorsiResult.miatabella!.forEach((element) {
      courseList.add(element);
    });
    return courseList;
  }
}