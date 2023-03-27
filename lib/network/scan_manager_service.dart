import 'package:http/http.dart' as http;
import 'package:lead_generation_flutter_app/model/check_manager_model/check_model.dart';
import 'package:lead_generation_flutter_app/network/vivaticket_api.dart';
import 'package:lead_generation_flutter_app/utils/envirorment.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

class ScanManagerService {
  final myTransformer = Xml2Json();

  Future<CheckManagerResult> requestCheckManager(
      String idmanifestazione,
      String codice20,
      String idutilizzatore,
      String idcorso,
      String ckexit,
      Envirorment envirorment) async {
    var envelope = '''
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <CheckManager xmlns="http://tempuri.org/">
            <idmanifestazione>$idmanifestazione</idmanifestazione>
            <codice20>$codice20</codice20>
            <idutilizzatore>$idutilizzatore</idutilizzatore>
            <idcorso>$idcorso</idcorso>
            <ckexit>$ckexit</ckexit>
          </CheckManager>
        </soap12:Body>
      </soap12:Envelope>
    ''';

    http.Response response = await http.post(
        Uri.parse(VivaticketApi.REQUEST_CHECK_MANAGER(envirorment)),
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
    AutogeneratedCheckMangerModel checkMangerModel =
        AutogeneratedCheckMangerModel.fromJson(responseJson);
    //LoginResult result = LoginResult.fromJson(responseJsonjj["soap:Envelope"]["soap:Body"]["LoginUtenteResponse"]["LoginUtenteResult"]);
    print("DATAResult=" + response.body);
    CheckManagerResult checkManagerResult = checkMangerModel
        .soapEnvelope!.soapBody!.checkManagerResponse!.checkManagerResult!;
    return checkManagerResult;
  }
}
