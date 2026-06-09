import '../models/user_model.dart';

class FirebaseAuthService {
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    
    return UserModel(
      id: 'user123',
      name: 'Test User',
      email: email,
      phone: '+1234567890',
      userType: UserType.tenant,
      createdAt: DateTime.now(),
    );
  }
  
  Future<UserModel> register(String name, String email, String password, UserType userType) async {
    await Future.delayed(Duration(seconds: 1));
    
    return UserModel(
      id: 'user123',
      name: name,
      email: email,
      phone: '+1234567890',
      userType: userType,
      createdAt: DateTime.now(),
    );
  }
  
  Future<void> logout() async {
    await Future.delayed(Duration(milliseconds: 500));
  }
}