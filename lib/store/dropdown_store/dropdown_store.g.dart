// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DropdownStore on _DropdownStore, Store {
  late final _$isSelectedAtom =
      Atom(name: '_DropdownStore.isSelected', context: context);

  @override
  bool get isSelected {
    _$isSelectedAtom.reportRead();
    return super.isSelected;
  }

  @override
  set isSelected(bool value) {
    _$isSelectedAtom.reportWrite(value, super.isSelected, () {
      super.isSelected = value;
    });
  }

  late final _$selectedItemAtom =
      Atom(name: '_DropdownStore.selectedItem', context: context);

  @override
  IdValueObject? get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(IdValueObject? value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  late final _$_DropdownStoreActionController =
      ActionController(name: '_DropdownStore', context: context);

  @override
  void setSelected(bool value) {
    final _$actionInfo = _$_DropdownStoreActionController.startAction(
        name: '_DropdownStore.setSelected');
    try {
      return super.setSelected(value);
    } finally {
      _$_DropdownStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedItem(IdValueObject value) {
    final _$actionInfo = _$_DropdownStoreActionController.startAction(
        name: '_DropdownStore.setSelectedItem');
    try {
      return super.setSelectedItem(value);
    } finally {
      _$_DropdownStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSelected: ${isSelected},
selectedItem: ${selectedItem}
    ''';
  }
}
