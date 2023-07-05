import 'package:http/http.dart' as http;
import 'package:lead_generation_flutter_app/model/response_logut_model/response_logout_model.dart';
import 'package:lead_generation_flutter_app/network/vivaticket_api.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

class LogoutService {
  final myTransformer = Xml2Json();

  Future<int> requestLogout(int idUtente, Envirorment envirorment) async {
    var envelope = '''
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <LogoutUtente xmlns="http://tempuri.org/">
            <idutente>$idUtente</idutente>
          </LogoutUtente>
        </soap12:Body>
      </soap12:Envelope>
    ''';

    http.Response response =
        await http.post(Uri.parse(VivaticketApi.REQUEST_LOGOUT(envirorment)),
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
    AutogeneratedLogout autogeneratedLogout =
        AutogeneratedLogout.fromJson(responseJson);
    //LoginResult result = LoginResult.fromJson(responseJsonjj["soap:Envelope"]["soap:Body"]["LoginUtenteResponse"]["LoginUtenteResult"]);

    return int.parse(autogeneratedLogout
        .soapEnvelope!.soapBody!.logoutUtenteResponse!.logoutUtenteResult!);
  }
}
