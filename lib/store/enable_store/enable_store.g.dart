// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EnableStore on _EnableStore, Store {
  late final _$isEnabledAtom =
      Atom(name: '_EnableStore.isEnabled', context: context);

  @override
  bool get isEnabled {
    _$isEnabledAtom.reportRead();
    return super.isEnabled;
  }

  @override
  set isEnabled(bool value) {
    _$isEnabledAtom.reportWrite(value, super.isEnabled, () {
      super.isEnabled = value;
    });
  }

  late final _$selectedItemAtom =
      Atom(name: '_EnableStore.selectedItem', context: context);

  @override
  bool? get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(bool? value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  late final _$_EnableStoreActionController =
      ActionController(name: '_EnableStore', context: context);

  @override
  void setEnabled(bool value) {
    final _$actionInfo = _$_EnableStoreActionController.startAction(
        name: '_EnableStore.setEnabled');
    try {
      return super.setEnabled(value);
    } finally {
      _$_EnableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEnabledItem(bool value) {
    final _$actionInfo = _$_EnableStoreActionController.startAction(
        name: '_EnableStore.setEnabledItem');
    try {
      return super.setEnabledItem(value);
    } finally {
      _$_EnableStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isEnabled: ${isEnabled},
selectedItem: ${selectedItem}
    ''';
  }
}
