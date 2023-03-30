abstract class EventRepository {
  Future<dynamic> getEvents(String? city);
  Future<dynamic> getEventDetails(int id);
}
