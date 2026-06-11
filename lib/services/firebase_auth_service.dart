import '../models/user_model.dart';
import '../models/property_model.dart';

// Firebase बिनाको Mock Service - सबै काम गर्छ
class FirebaseService {
  
  // Test Connection
  static Future<bool> testConnection() async {
    print('🔍 Testing connection...');
    await Future.delayed(Duration(milliseconds: 500));
    print('✅ Connection successful!');
    return true;
  }
  
  // User Register
  static Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String phone,
    required String userType,
  }) async {
    try {
      print('📝 Registering user: $name, $email');
      await Future.delayed(Duration(seconds: 1));
      
      print('✅✅✅ USER SAVED! ✅✅✅');
      
      return UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        userType: userType == 'tenant' ? UserType.tenant : UserType.landlord,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('❌❌❌ ERROR: $e ❌❌❌');
      return null;
    }
  }
  
  // Get All Users
  static Future<void> getAllUsers() async {
    print('🔍 Fetching all users...');
    await Future.delayed(Duration(milliseconds: 500));
    print('📊 Total users: 0 (Mock mode)');
  }
  
  // Add Property
  static Future<bool> addProperty({
    required String title,
    required String description,
    required double price,
    required String address,
    required int bedrooms,
    required int bathrooms,
    required double area,
    required String landlordId,
    required String status,
  }) async {
    try {
      print('📝 Adding property: $title');
      await Future.delayed(Duration(seconds: 1));
      
      print('✅✅✅ PROPERTY SAVED! ✅✅✅');
      return true;
    } catch (e) {
      print('❌❌❌ ERROR: $e ❌❌❌');
      return false;
    }
  }
}