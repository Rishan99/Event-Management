import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/data/core/http_service.dart';
import 'package:event_management/services/service.dart';

class EventRepositoryImpl implements EventRepository {
  final HttpService httpService;
  EventRepositoryImpl(this.httpService);

  @override
  Future<List<dynamic>> getEventDetails(int id) async {
    try {
      final Response response = await httpService.getData(ApiUrl.eventDetail(id));
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getEvents(String? city) async {
    try {
      final Response response = await httpService.getData(ApiUrl.eventList, data: {
        'city': city,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
