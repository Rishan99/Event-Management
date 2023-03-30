abstract class EventRepository {
  Future<List<dynamic>> getEvents(String? city);
  Future<dynamic> getEventDetails(int id);
}
