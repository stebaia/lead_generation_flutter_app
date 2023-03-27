// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infoCurrentPeopleBox_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InfoCurrentPeopleBoxStore on _InfoCurrentPeopleBoxStore, Store {
  Computed<bool>? _$hasResultsComputed;

  @override
  bool get hasResults =>
      (_$hasResultsComputed ??= Computed<bool>(() => super.hasResults,
              name: '_InfoCurrentPeopleBoxStore.hasResults'))
          .value;

  late final _$fetchVisitorsFutureAtom = Atom(
      name: '_InfoCurrentPeopleBoxStore.fetchVisitorsFuture', context: context);

  @override
  ObservableFuture<int> get fetchVisitorsFuture {
    _$fetchVisitorsFutureAtom.reportRead();
    return super.fetchVisitorsFuture;
  }

  @override
  set fetchVisitorsFuture(ObservableFuture<int> value) {
    _$fetchVisitorsFutureAtom.reportWrite(value, super.fetchVisitorsFuture, () {
      super.fetchVisitorsFuture = value;
    });
  }

  late final _$visitorStateAtom =
      Atom(name: '_InfoCurrentPeopleBoxStore.visitorState', context: context);

  @override
  int get visitorState {
    _$visitorStateAtom.reportRead();
    return super.visitorState;
  }

  @override
  set visitorState(int value) {
    _$visitorStateAtom.reportWrite(value, super.visitorState, () {
      super.visitorState = value;
    });
  }

  late final _$fetchVisitorsAsyncAction =
      AsyncAction('_InfoCurrentPeopleBoxStore.fetchVisitors', context: context);

  @override
  Future<int> fetchVisitors(
      String idmanifestazione, String codice20, Envirorment envirorment) {
    return _$fetchVisitorsAsyncAction.run(
        () => super.fetchVisitors(idmanifestazione, codice20, envirorment));
  }

  late final _$_InfoCurrentPeopleBoxStoreActionController =
      ActionController(name: '_InfoCurrentPeopleBoxStore', context: context);

  @override
  void setScanState(int value) {
    final _$actionInfo = _$_InfoCurrentPeopleBoxStoreActionController
        .startAction(name: '_InfoCurrentPeopleBoxStore.setScanState');
    try {
      return super.setScanState(value);
    } finally {
      _$_InfoCurrentPeopleBoxStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchVisitorsFuture: ${fetchVisitorsFuture},
visitorState: ${visitorState},
hasResults: ${hasResults}
    ''';
  }
}
