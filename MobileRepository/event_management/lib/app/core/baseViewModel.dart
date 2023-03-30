import 'package:event_management/core/utils/utils.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.busy;
  ViewState get state => _state;
  bool isMounted = false;
  String errorMessage = "";
  late final BuildContext context;

  initializeContext(BuildContext context) {
    this.context = context;
    mountWidget();
  }

  void updateState(ViewState viewState) {
    if (context.mounted) {
      _state = viewState;
      setState();
    }
  }

  void setState() {
    notifyListeners();
  }

  mountWidget() {
    isMounted = true;
  }

  disMountWidget() {
    isMounted = false;
  }
}
