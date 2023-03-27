import 'package:mobx/mobx.dart';

part 'selected_item_store.g.dart';

class SelectedItemyStore = _SelectedItemyStore with _$SelectedItemyStore;

abstract class _SelectedItemyStore with Store {
  @observable
  String? selectedItem;

  @action
  void setSelectedItem(String value) {
    selectedItem = value;
  }
}
