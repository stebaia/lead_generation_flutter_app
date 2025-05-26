// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FormStore on _FormStore, Store {
  late final _$isValidAtom = Atom(name: '_FormStore.isValid', context: context);

  @override
  bool get isValid {
    _$isValidAtom.reportRead();
    return super.isValid;
  }

  @override
  set isValid(bool value) {
    _$isValidAtom.reportWrite(value, super.isValid, () {
      super.isValid = value;
    });
  }

  late final _$isVisibileAtom =
      Atom(name: '_FormStore.isVisibile', context: context);

  @override
  bool get isVisibile {
    _$isVisibileAtom.reportRead();
    return super.isVisibile;
  }

  @override
  set isVisibile(bool value) {
    _$isVisibileAtom.reportWrite(value, super.isVisibile, () {
      super.isVisibile = value;
    });
  }

  late final _$emailAtom = Atom(name: '_FormStore.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_FormStore.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_FormStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$hasErrorAtom =
      Atom(name: '_FormStore.hasError', context: context);

  @override
  bool get hasError {
    _$hasErrorAtom.reportRead();
    return super.hasError;
  }

  @override
  set hasError(bool value) {
    _$hasErrorAtom.reportWrite(value, super.hasError, () {
      super.hasError = value;
    });
  }

  late final _$_FormStoreActionController =
      ActionController(name: '_FormStore', context: context);

  @override
  void setEmail(String value) {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loginAction() {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.loginAction');
    try {
      return super.loginAction();
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setVisibility(bool value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setVisibility');
    try {
      return super.setVisibility(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? message) {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.setError');
    try {
      return super.setError(message);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isValid: ${isValid},
isVisibile: ${isVisibile},
email: ${email},
password: ${password},
errorMessage: ${errorMessage},
hasError: ${hasError}
    ''';
  }
}
