// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_item_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SelectedItemyStore on _SelectedItemyStore, Store {
  late final _$selectedItemAtom =
      Atom(name: '_SelectedItemyStore.selectedItem', context: context);

  @override
  String? get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(String? value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  late final _$_SelectedItemyStoreActionController =
      ActionController(name: '_SelectedItemyStore', context: context);

  @override
  void setSelectedItem(String value) {
    final _$actionInfo = _$_SelectedItemyStoreActionController.startAction(
        name: '_SelectedItemyStore.setSelectedItem');
    try {
      return super.setSelectedItem(value);
    } finally {
      _$_SelectedItemyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedItem: ${selectedItem}
    ''';
  }
}
