// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visibility_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VisibilityStore on _VisibilityStore, Store {
  late final _$isVisibleAtom =
      Atom(name: '_VisibilityStore.isVisible', context: context);

  @override
  bool get isVisible {
    _$isVisibleAtom.reportRead();
    return super.isVisible;
  }

  @override
  set isVisible(bool value) {
    _$isVisibleAtom.reportWrite(value, super.isVisible, () {
      super.isVisible = value;
    });
  }

  late final _$selectedItemAtom =
      Atom(name: '_VisibilityStore.selectedItem', context: context);

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

  late final _$_VisibilityStoreActionController =
      ActionController(name: '_VisibilityStore', context: context);

  @override
  void setSelected(bool value) {
    final _$actionInfo = _$_VisibilityStoreActionController.startAction(
        name: '_VisibilityStore.setSelected');
    try {
      return super.setSelected(value);
    } finally {
      _$_VisibilityStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedItem(bool value) {
    final _$actionInfo = _$_VisibilityStoreActionController.startAction(
        name: '_VisibilityStore.setSelectedItem');
    try {
      return super.setSelectedItem(value);
    } finally {
      _$_VisibilityStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isVisible: ${isVisible},
selectedItem: ${selectedItem}
    ''';
  }
}
