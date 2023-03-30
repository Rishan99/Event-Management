import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/data/core/http_service.dart';
import 'package:event_management/demoData.dart';
import 'package:event_management/services/service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HttpService httpService;
  AuthRepositoryImpl(this.httpService);

  @override
  Future login(String username, String password) async {
    try {
      await demoDelay();
      if (username == 'test@gmail.com' && password == 'test123') {
        return {'accessToken': "testToken"};
      }
      throw "Invalid Username or Password";
      final Response response = await httpService.postRequestWithoutAuth(
        ApiUrl.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> register(String name, String username, String password) async {
    try {
      await demoDelay();
      if (username == 'test@gmail.com') {
        throw "User with email ${username} has already been registered";
      }
      return "Success";
      final Response response = await httpService.postRequestWithoutAuth(
        ApiUrl.login,
        data: {
          'username': username,
          'name': name,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
