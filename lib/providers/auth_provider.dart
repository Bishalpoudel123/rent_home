import 'package:flutter/material.dart';
import 'package:nepal_rent_app/services/firebase_auth_service.dart';
import '../models/user_model.dart';
//import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  // ✅ Register - Firebase मा save गर्ने
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
    
    try {
      final userTypeString = userType == UserType.tenant ? 'tenant' : 'landlord';
      
      _currentUser = await FirebaseService.registerUser(
        name: name,
        email: email,
        phone: phone,
        userType: userTypeString,
      );
      
      if (_currentUser != null) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'रजिस्टर असफल भयो';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Login (सजिलोको लागि mock)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await Future.delayed(Duration(seconds: 1));
      
      _currentUser = UserModel(
        id: 'temp_user',
        name: email.split('@')[0],
        email: email,
        phone: '9800000000',
        userType: UserType.tenant,
        createdAt: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'लगइन असफल भयो';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 500));
    _currentUser = null;
    
    _isLoading = false;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}