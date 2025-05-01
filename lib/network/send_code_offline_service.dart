import 'package:lead_generation_flutter_app/model/send_offline_model/send_offline_model.dart';
import 'package:lead_generation_flutter_app/model/visitor_model/visitors_object.dart';
import 'package:lead_generation_flutter_app/network/vivaticket_api.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:convert';

class SendOfflineService {
  final myTransformer = Xml2Json();

  Future<String> sendOffline(
      String idManifestazione,
      String idCorso,
      String idUtilizzatore,
      String dataOra,
      String ckExit,
      String codice20,
      Envirorment envirorment) async {
    var envelope = '''
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <SendOffline xmlns="http://tempuri.org/">
            <idmanifestazione>$idManifestazione</idmanifestazione>
            <codice20>$codice20</codice20>
            <idutilizzatore>$idUtilizzatore</idutilizzatore>
            <dataora>$dataOra</dataora>
            <idcorso>$idCorso</idcorso>
            <ckexit>$ckExit</ckexit>
          </SendOffline>
        </soap12:Body>
      </soap12:Envelope>
    ''';

    http.Response response = await http.post(
        Uri.parse(VivaticketApi.REQUEST_SEND_OFFLINE(envirorment)),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          //"SOAPAction": "http://tempuri.org/GetAllCity",
          //"Host": "www.i2isoftwares.com"
          "Accept": "text/xml"
        },
        body: envelope);

    var rawXmlResponse = response.body;

// Use the xml package's 'parse' method to parse the response.
    try {
      XmlDocument customParseXml = XmlDocument.parse(rawXmlResponse);
      myTransformer.parse(rawXmlResponse);
      var jsonResponse = myTransformer.toParker();
      Map<String, dynamic> responseJson = json.decode(jsonResponse);

      SendOffileResponse corseResponse =
          SendOffileResponse.fromJson(responseJson);
      //LoginResult result = LoginResult.fromJson(responseJsonjj["soap:Envelope"]["soap:Body"]["LoginUtenteResponse"]["LoginUtenteResult"]);
      print("DATAResult=" + response.body);
      String getCorsiResult = corseResponse
          .soapEnvelope!.soapBody!.sendOfflineResponse!.sendOfflineResult!;
      return getCorsiResult;
    } catch (ex) {
      return "error";
    }
  }
}
