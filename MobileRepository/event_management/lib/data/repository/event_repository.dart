import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/data/core/http_service.dart';
import 'package:event_management/demoData.dart';
import 'package:event_management/services/service.dart';

class EventRepositoryImpl implements EventRepository {
  final HttpService httpService;
  EventRepositoryImpl(this.httpService);

  @override
  Future<dynamic> getEventDetails(int id) async {
    try {
      await demoDelay();
      return eventModel(id).toMap();
      final Response response = await httpService.getData(ApiUrl.eventDetail(id));
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getEvents(String? city) async {
    try {
      await demoDelay();
      return events.map((e) => e.toMap()).toList();
      final Response response = await httpService.getData(ApiUrl.eventList, data: {
        'city': city,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
