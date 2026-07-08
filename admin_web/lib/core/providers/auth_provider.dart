import 'package:flutter/material.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  String _userName = '';
  String _userRole = '';
  String _userInitials = '';
  String _currentBranch = 'Downtown Branch';

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String get userName => _userName;
  String get userRole => _userRole;
  String get userInitials => _userInitials;
  String get currentBranch => _currentBranch;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isNotEmpty && password.isNotEmpty) {
      _userName = 'Alex Rivera';
      _userRole = 'General Manager';
      _userInitials = 'AR';
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    _userName = '';
    _userRole = '';
    _userInitials = '';
    notifyListeners();
  }

  void setBranch(String branch) {
    _currentBranch = branch;
    notifyListeners();
  }
}
