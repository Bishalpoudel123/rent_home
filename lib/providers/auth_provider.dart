import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  // Register - सिधै काम गर्छ
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserType userType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    print('📝 Registering: $name, $email');
    
    try {
      // नेटवर्क कल जस्तो
      await Future.delayed(Duration(seconds: 1));
      
      // नयाँ यूजर बनाउने
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        userType: userType,
        createdAt: DateTime.now(),
      );
      
      print('✅ Registration successful!');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'रजिस्टर असफल भयो। फेरि प्रयास गर्नुहोस्।';
      print('❌ Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    print('📝 Logging in: $email');
    
    try {
      await Future.delayed(Duration(seconds: 1));
      
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@')[0],
        email: email,
        phone: '9800000000',
        userType: UserType.tenant,
        createdAt: DateTime.now(),
      );
      
      print('✅ Login successful!');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'लगइन असफल भयो। कृपया फेरि प्रयास गर्नुहोस्।';
      print('❌ Login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    print('📝 Logging out');
    _currentUser = null;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}