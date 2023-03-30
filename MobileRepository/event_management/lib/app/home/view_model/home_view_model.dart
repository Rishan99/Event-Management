import 'package:event_management/app/core/baseViewModel.dart';
import 'package:event_management/core/utils/enum/enum.dart';
import 'package:event_management/model/event_model.dart';
import 'package:event_management/services/provider/city_provider.dart';
import 'package:event_management/services/service.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends BaseViewModel {
  final EventService _eventService;
  List<EventModel> eventList = [];
  List<EventModel> _realEventList = [];

  HomeViewModel(this._eventService);

  DateTime? filterStartDate;
  DateTime? filterEndDate;

  Future<void> getEventList() async {
    try {
      updateState(ViewState.busy);
      final _selectedCity = Provider.of<CityProvider>(context, listen: false).selectedCity;
      _realEventList = await _eventService.getEventList(_selectedCity);
      eventList = _realEventList;
      updateState(ViewState.idle);
    } catch (e) {
      errorMessage = e.toString();
      updateState(ViewState.error);
    }
  }

  onFilterValueUpdate(DateTime? filterStartDate, DateTime? filterEndDate) {
    this.filterStartDate = filterStartDate;
    this.filterEndDate = filterEndDate;
    _onFilter();
  }

  _onFilter() {
    if (filterStartDate == null && filterEndDate == null) {
      eventList = _realEventList;
    } else {
      eventList = _realEventList.where((element) {
        return ((filterStartDate == null ? true : ((DateTime.parse(element.startDate).isAfter(filterStartDate!)) || (DateTime.parse(element.startDate).isAtSameMomentAs(filterStartDate!)))) &&
            (filterEndDate == null
                ? true
                : element.endDate == null
                    ? false
                    : ((DateTime.parse(element.endDate!).isBefore(filterEndDate!)) || (DateTime.parse(element.endDate!).isAtSameMomentAs(filterEndDate!)))));
      }).toList();
    }
    updateState(ViewState.idle);
  }
}
