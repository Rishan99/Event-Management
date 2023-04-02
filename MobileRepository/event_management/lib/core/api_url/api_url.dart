// ignore_for_file: file_names

class ApiUrl {
  //Private Constructor to restrict creating instance of class
  ApiUrl._();
  static String baseUrl = 'http://festivalika.rishanshrestha.com.np/api/';
  static String weatherApiBaseUrl = "https://api.openweathermap.org/data/2.5/";
  static String weatherImageBaseUrl = "https://openweathermap.org/img/wn/";

  static String hourlyCityUrl = "forecast";

  //Auth
  static String login = "auth/login-user";
  static String register = "auth/register-user";
  //User
  static String profileDetail = "auth/me";
  //Event
  static String eventList = "event/query";
  static String eventDetail(int id) => "event/$id";
  static String purchaseTicket(int id) => "event/$id/purchase-ticket";
}
