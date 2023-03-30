abstract class AuthRepository {
  Future<dynamic> login(String username, String password);
  Future<dynamic> register(
    String name,
    String username,
    String password,
  );
}
