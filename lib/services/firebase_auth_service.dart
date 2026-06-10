import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/property_model.dart';

class FirebaseService {
  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  
  // ✅ User Register गर्ने (Firebase मा save गर्ने)
  static Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String phone,
    required String userType,
  }) async {
    try {
      final userData = {
        'name': name,
        'email': email,
        'phone': phone,
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      // Firestore मा user save गर्ने
      final docRef = await _firestore.collection('users').add(userData);
      
      print('✅ User saved with ID: ${docRef.id}');
      
      return UserModel(
        id: docRef.id,
        name: name,
        email: email,
        phone: phone,
        userType: userType == 'tenant' ? UserType.tenant : UserType.landlord,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }
  
  // ✅ Test Data पठाउने (Check गर्नको लागि)
  static Future<void> addTestData() async {
    try {
      await _firestore.collection('test').add({
        'message': 'Hello from Flutter App!',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Test data added!');
    } catch (e) {
      print('❌ Error: $e');
    }
  }
  
  // ✅ Firestore Connection Check
  static Future<bool> checkConnection() async {
    try {
      await _firestore.collection('test').limit(1).get();
      print('✅ Firestore connected!');
      return true;
    } catch (e) {
      print('❌ Connection failed: $e');
      return false;
    }
  }
}