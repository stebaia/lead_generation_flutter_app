import 'package:mobx/mobx.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';

import '../../network/visitors_service.dart';

part 'infoCurrentPeopleBox_store.g.dart';

class InfoCurrentPeopleBoxStore = _InfoCurrentPeopleBoxStore
    with _$InfoCurrentPeopleBoxStore;

abstract class _InfoCurrentPeopleBoxStore with Store {
  VisitorsService visitorsService = VisitorsService();

  @observable
  ObservableFuture<int> fetchVisitorsFuture = emptyResponse;

  @observable
  int visitorState = 0;

  @computed
  bool get hasResults =>
      fetchVisitorsFuture != emptyResponse &&
      fetchVisitorsFuture.status == FutureStatus.fulfilled;

  static ObservableFuture<int> emptyResponse = ObservableFuture.value(0);

  @action
  Future<int> fetchVisitors(
      String idmanifestazione, String codice20, Envirorment envirorment) async {
    final future = visitorsService.requestVisitors(
        idmanifestazione, int.parse(codice20), envirorment);

    fetchVisitorsFuture = ObservableFuture(future);
    return visitorState = await future;
  }

  @action
  void setScanState(int value) {
    visitorState = value;
  }
}
