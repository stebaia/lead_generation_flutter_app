import 'package:mobx/mobx.dart';

part 'visibility_store.g.dart';

class VisibilityStore = _VisibilityStore with _$VisibilityStore;

abstract class _VisibilityStore with Store {
  @observable
  bool isVisible = true;

  @observable
  bool? selectedItem;

  @action
  void setSelected(bool value) {
    isVisible = value;
  }

  @action
  void setSelectedItem(bool value) {
    selectedItem = value;
  }
}
