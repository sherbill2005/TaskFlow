class AuthService {
  // Hardcoded list of valid users (username and password pairs)
  final Map<String, String> _users = {
    'zaid': '200',
    'nasir': '253',
    'zain': '219',
    'hamza': '124',
    'a': '1',
  };

  // Method to authenticate the user
  bool authenticate(String username, String password) {
    if (_users.containsKey(username) && _users[username] == password) {
      return true;
    }
    return false;
  }
}
