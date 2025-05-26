import 'dart:ffi';

import 'package:mobx/mobx.dart';

part 'form_store.g.dart';

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore with Store {
  @observable
  bool isValid = false;

  @observable
  bool isVisibile = true;

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String? errorMessage;

  @observable
  bool hasError = false;

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void loginAction() {
    if (email != "" && password != "") {
      isValid = true;
    } else {
      isValid = false;
    }
  }

  @action
  setVisibility(bool value) {
    isVisibile = value;
  }

  @action
  void setError(String? message) {
    errorMessage = message;
    hasError = message != null;
  }

  @action
  void clearError() {
    errorMessage = null;
    hasError = false;
  }
}
