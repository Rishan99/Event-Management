import 'package:event_management/core/utils/utils.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.busy;
  ViewState get state => _state;
  String errorMessage = "";
  late final BuildContext context;

  initializeContext(BuildContext context) {
    this.context = context;
  }

  void updateState(ViewState viewState) {
    _state = viewState;
    setState();
  }

  void setState() {
    notifyListeners();
  }
}
