import 'package:mobx/mobx.dart';

part 'enable_store.g.dart';

class EnableStore = _EnableStore with _$EnableStore;

abstract class _EnableStore with Store {
  @observable
  bool isEnabled = false;

  @observable
  bool? selectedItem;

  @action
  void setEnabled(bool value) {
    isEnabled = value;
  }

  @action
  void setEnabledItem(bool value) {
    selectedItem = value;
  }
}
