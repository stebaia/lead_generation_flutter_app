import 'package:mobx/mobx.dart';
import 'package:lead_generation_flutter_app/model/id_value_model.dart';

part 'dropdown_store.g.dart';

class DropdownStore = _DropdownStore with _$DropdownStore;

abstract class _DropdownStore with Store {
  @observable
  bool isSelected = false;

  @observable
  IdValueObject? selectedItem;

  @action
  void setSelected(bool value) {
    isSelected = value;
  }

  @action
  void setSelectedItem(IdValueObject value) {
    selectedItem = value;
  }
}
