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
      final data = await httpService.postRequestWithoutAuth(
        ApiUrl.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> register(String name, String username, String password) async {
    try {
      final response = await httpService.postRequestWithoutAuth(
        ApiUrl.register,
        data: {
          'username': username,
          'name': name,
          'password': password,
          'confirmPassword': password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
