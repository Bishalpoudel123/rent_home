import 'package:flutter/material.dart';

class RoomStatusUpdateScreen extends StatefulWidget {
  final String propertyId;
  final String propertyTitle;
  
  const RoomStatusUpdateScreen({
    Key? key,
    required this.propertyId,
    required this.propertyTitle,
  }) : super(key: key);
  
  @override
  _RoomStatusUpdateScreenState createState() => _RoomStatusUpdateScreenState();
}

class _RoomStatusUpdateScreenState extends State<RoomStatusUpdateScreen> {
  bool _isRoomAvailable = true;
  bool _isUpdating = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('कोठाको स्थिति अपडेट गर्नुहोस्'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.home, color: Colors.blue.shade700, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'कोठा:',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          widget.propertyTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Current Status Display
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRoomAvailable ? Colors.green.shade50 : Colors.red.shade50,
                ),
                child: Icon(
                  _isRoomAvailable ? Icons.check_circle : Icons.cancel,
                  size: 80,
                  color: _isRoomAvailable ? Colors.green : Colors.red,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Center(
              child: Text(
                _isRoomAvailable ? 'कोठा हाल खाली छ' : 'कोठा भाडामा दिइसकियो',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isRoomAvailable ? Colors.green : Colors.red,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Status Toggle Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'कोठाको स्थिति:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Switch(
                        value: _isRoomAvailable,
                        onChanged: (value) {
                          setState(() {
                            _isRoomAvailable = value;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isRoomAvailable ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isRoomAvailable ? Icons.info : Icons.warning,
                          color: _isRoomAvailable ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isRoomAvailable 
                                ? '✅ उपलब्ध - खोजी गर्नेहरूले यो कोठा देख्न सक्छन्'
                                : '❌ भाडामा दिइसकियो - खोजी गर्नेहरूले यो कोठा देख्न पाउने छैनन्',
                            style: TextStyle(
                              color: _isRoomAvailable ? Colors.green : Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUpdating ? null : _updateRoomStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRoomAvailable ? Colors.green : Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isRoomAvailable ? 'कोठा खाली छ भनेर पुष्टि गर्नुहोस्' : 'कोठा भाडामा दिइसकियो भनेर पुष्टि गर्नुहोस्',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('रद्द गर्नुहोस्'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _updateRoomStatus() async {
    setState(() {
      _isUpdating = true;
    });
    
    // यहाँ API call गर्ने - स्थिति मात्र अपडेट गर्ने
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isUpdating = false;
    });
    
    // Success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRoomAvailable 
              ? '✅ कोठा खाली छ भनेर सफलतापूर्वक अपडेट गरियो!'
              : '✅ कोठा भाडामा दिइसकियो भनेर सफलतापूर्वक अपडेट गरियो!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Page बन्द गर्ने
    Navigator.pop(context, true);
  }
}