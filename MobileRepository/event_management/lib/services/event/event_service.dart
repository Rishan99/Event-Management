import 'package:event_management/model/event_detail_model.dart';
import 'package:event_management/model/event_model.dart';

import 'event_repository.dart';

class EventService {
  final EventRepository eventRepository;
  EventService(this.eventRepository);

  Future<List<EventModel>> getEventList(String? city) async {
    final List<dynamic> data = await eventRepository.getEvents(city);
    return data.map((e) => EventModel.fromMap(e)).toList();
  }

  Future<EventDetailModel> getEventDetail(int id) async {
    final dynamic data = await eventRepository.getEventDetails(id);
    return EventDetailModel.fromMap(data);
  }
}
