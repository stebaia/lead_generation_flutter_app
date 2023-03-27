// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottomNavigation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BottomNavigationStore on _BottomNavigationStore, Store {
  late final _$selectedIndexAtom =
      Atom(name: '_BottomNavigationStore.selectedIndex', context: context);

  @override
  int get selectedIndex {
    _$selectedIndexAtom.reportRead();
    return super.selectedIndex;
  }

  @override
  set selectedIndex(int value) {
    _$selectedIndexAtom.reportWrite(value, super.selectedIndex, () {
      super.selectedIndex = value;
    });
  }

  late final _$_BottomNavigationStoreActionController =
      ActionController(name: '_BottomNavigationStore', context: context);

  @override
  void setSelected(int value) {
    final _$actionInfo = _$_BottomNavigationStoreActionController.startAction(
        name: '_BottomNavigationStore.setSelected');
    try {
      return super.setSelected(value);
    } finally {
      _$_BottomNavigationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedIndex: ${selectedIndex}
    ''';
  }
}
