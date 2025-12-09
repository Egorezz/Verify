class UserSession {
  final String name;
  final String login;
  final String jwtToken;

  UserSession({
    required this.name,
    required this.login,
    required this.jwtToken,
  });
}
