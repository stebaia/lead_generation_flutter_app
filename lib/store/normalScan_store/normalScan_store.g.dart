// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'normalScan_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NormalScanStore on _NormalScanStore, Store {
  Computed<bool>? _$hasResultsComputed;

  @override
  bool get hasResults =>
      (_$hasResultsComputed ??= Computed<bool>(() => super.hasResults,
              name: '_NormalScanStore.hasResults'))
          .value;

  late final _$fetchScanResultAtom =
      Atom(name: '_NormalScanStore.fetchScanResult', context: context);

  @override
  ObservableFuture<CheckManagerResult> get fetchScanResult {
    _$fetchScanResultAtom.reportRead();
    return super.fetchScanResult;
  }

  @override
  set fetchScanResult(ObservableFuture<CheckManagerResult> value) {
    _$fetchScanResultAtom.reportWrite(value, super.fetchScanResult, () {
      super.fetchScanResult = value;
    });
  }

  late final _$scanStateAtom =
      Atom(name: '_NormalScanStore.scanState', context: context);

  @override
  CheckManagerResult get scanState {
    _$scanStateAtom.reportRead();
    return super.scanState;
  }

  @override
  set scanState(CheckManagerResult value) {
    _$scanStateAtom.reportWrite(value, super.scanState, () {
      super.scanState = value;
    });
  }

  late final _$fetchScanAsyncAction =
      AsyncAction('_NormalScanStore.fetchScan', context: context);

  @override
  Future<CheckManagerResult> fetchScan(
      String idmanifestazione,
      String codice20,
      String idutilizzatore,
      String idcorso,
      String ckexit,
      Envirorment envirorment) {
    return _$fetchScanAsyncAction.run(() => super.fetchScan(idmanifestazione,
        codice20, idutilizzatore, idcorso, ckexit, envirorment));
  }

  late final _$_NormalScanStoreActionController =
      ActionController(name: '_NormalScanStore', context: context);

  @override
  void setScanState(CheckManagerResult value) {
    final _$actionInfo = _$_NormalScanStoreActionController.startAction(
        name: '_NormalScanStore.setScanState');
    try {
      return super.setScanState(value);
    } finally {
      _$_NormalScanStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchScanResult: ${fetchScanResult},
scanState: ${scanState},
hasResults: ${hasResults}
    ''';
  }
}
