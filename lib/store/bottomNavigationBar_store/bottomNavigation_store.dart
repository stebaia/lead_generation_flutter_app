import 'package:mobx/mobx.dart';
import 'package:lead_generation_flutter_app/model/id_value_model.dart';

part 'bottomNavigation_store.g.dart';

class BottomNavigationStore = _BottomNavigationStore
    with _$BottomNavigationStore;

abstract class _BottomNavigationStore with Store {
  @observable
  int selectedIndex = 0;

  @action
  void setSelected(int value) {
    selectedIndex = value;
  }
}
