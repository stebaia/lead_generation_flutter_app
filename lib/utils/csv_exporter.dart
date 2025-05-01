import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:external_path/external_path.dart';
import 'package:csv/csv.dart';
import 'package:flutter_share/flutter_share.dart';
import '../model/expositor_mapper/expositor_mapper.dart';
import 'package:share_plus/share_plus.dart';

class CsvExporter {
  Future<void> shareFile(String path) async {
    Share.shareFiles([path]);
  }

  void generateCsvFile(List<ExpoisitorMapper> expositors) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    List<List<dynamic>> rows = [];

    List<dynamic> row = [];
    row.add("Nome");
    row.add("Cognome");
    row.add("Email");
    row.add("Telefono");
    row.add("Cap");
    row.add("Sigla Provincia");
    row.add("Sigla Nazione");
    row.add("Privacy Commericiale");
    row.add("Ragione Sociale");
    row.add("Note");
    rows.add(row);
    for (int i = 0; i < expositors.length; i++) {
      List<dynamic> row = [];
      row.add(expositors[i].nome);
      row.add(expositors[i].cognome);
      row.add(expositors[i].email);
      row.add(expositors[i].telefono);
      row.add(expositors[i].cap);
      row.add(expositors[i].siglaprovincia);
      row.add(expositors[i].siglanazione);
      row.add(expositors[i].privacyCommerciale);
      row.add(expositors[i].ragionesociale);
      row.add(expositors[i].note);

      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    if (Platform.isAndroid) {
      Directory? dir = await getDownloadsDirectory();
      if (dir != null) {
        print(dir);
        String file = dir.path;
        File f = File(file + "/esportazione_offline_scan.csv");
        f.writeAsString(csv);

        shareFile(f.path);
      }

      /*String dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      print("dir $dir");
      String file = "$dir";

      File f = File(file + "/esportazione_espositori.csv");

      f.writeAsString(csv);

      shareFile(f.path);
      */
    } else {
      Directory documents = await getApplicationDocumentsDirectory();

      String file = documents.path;

      File f = File(file + "/esportazione_offline_scan.csv");

      f.writeAsString(csv);

      shareFile(f.path);
    }
  }
}
