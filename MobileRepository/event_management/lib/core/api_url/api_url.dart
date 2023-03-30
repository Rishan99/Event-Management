// ignore_for_file: file_names

class ApiUrl {
  //Private Constructor to restrict creating instance of class
  ApiUrl._();
  static String baseUrl = '';
  static String weaterApiBaseUrl = "https://pro.openweathermap.org/data/2.5/forecast/";
//

  static String hourlyCityUrl = "hourly";

  //Auth
  static String login = "auth/login";
  static String signup = "auth/signup";
  //User
  static String profileDetail = "auth/me";
  //Event
  static String eventList = "events";
  static String eventDetail(int id) => "event/$id";
}
