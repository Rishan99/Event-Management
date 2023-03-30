import 'package:event_management/app/core/baseViewModel.dart';
import 'package:event_management/core/utils/enum/enum.dart';
import 'package:event_management/model/event_detail_model.dart';
import 'package:event_management/model/event_model.dart';
import 'package:event_management/services/provider/city_provider.dart';
import 'package:event_management/services/service.dart';
import 'package:provider/provider.dart';

class EventDetailViewModel extends BaseViewModel {
  final EventService _eventService;
  late final int id;
  EventDetailModel? eventModel;

  EventDetailViewModel(this._eventService);

  intializeValue(int id) {
    this.id = id;
    getEventDetail();
  }

  Future<void> getEventDetail() async {
    try {
      updateState(ViewState.busy);
      eventModel = await _eventService.getEventDetail(id);
      updateState(ViewState.idle);
    } catch (e) {
      errorMessage = e.toString();
      updateState(ViewState.error);
    }
  }

  bool get allowBooking => eventModel == null ? false : eventModel?.booking == null;
}
