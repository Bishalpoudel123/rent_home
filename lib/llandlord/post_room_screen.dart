import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property_model.dart';
import '../providers/property_provider.dart';

class PostRoomScreen extends StatefulWidget {
  @override
  _PostRoomScreenState createState() => _PostRoomScreenState();
}

class _PostRoomScreenState extends State<PostRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _bedroomController = TextEditingController();
  final _bathroomController = TextEditingController();
  final _areaController = TextEditingController();
  bool _isPosting = false;
  
  // 🔴 पक्कै Available चयन गर्नुहोस्
  PropertyStatus _selectedStatus = PropertyStatus.available;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('नयाँ कोठा पोस्ट गर्नुहोस्'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'कोठाको शीर्षक *',
                  hintText: 'जस्तै: सुन्दर २ बेडरुम अपार्टमेन्ट',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया कोठाको शीर्षक राख्नुहोस्';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'विवरण *',
                  hintText: 'कोठाको बारेमा विस्तृत जानकारी...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया कोठाको विवरण राख्नुहोस्';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'मासिक भाडा (रु.) *',
                  hintText: 'जस्तै: 8000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.currency_rupee),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया मासिक भाडा राख्नुहोस्';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'ठेगाना *',
                  hintText: 'जस्तै: ललितपुर, कुपन्डोल',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया ठेगाना राख्नुहोस्';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bedroomController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'शयनकक्ष',
                        hintText: 'जस्तै: 2',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.bed),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _bathroomController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'स्नानगृह',
                        hintText: 'जस्तै: 2',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.bathtub),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _areaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'क्षेत्रफल (वर्ग फिट)',
                  hintText: 'जस्तै: 550',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.square_foot),
                ),
              ),
              const SizedBox(height: 16),
              
              // 🔴 Status Selection - Available चयन गर्नुपर्छ
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'कोठाको स्थिति (पक्कै "उपलब्ध" चयन गर्नुहोस्):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<PropertyStatus>(
                            title: const Text('✅ उपलब्ध (खाली) - सबैले देख्नेछन्'),
                            value: PropertyStatus.available,
                            groupValue: _selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                            activeColor: Colors.green,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<PropertyStatus>(
                            title: const Text('❌ भाडामा दिइसकियो - लुकाइनेछ'),
                            value: PropertyStatus.rented,
                            groupValue: _selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                            activeColor: Colors.red,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedStatus == PropertyStatus.available
                                  ? '✅ यो कोठा Home Screen मा देखिनेछ'
                                  : '❌ यो कोठा Home Screen मा देखिने छैन',
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedStatus == PropertyStatus.available 
                                    ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isPosting ? null : _postProperty,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isPosting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'कोठा पोस्ट गर्नुहोस्',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _postProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isPosting = true;
      });
      
      // नयाँ कोठा बनाउने
      final newProperty = PropertyModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        address: _addressController.text,
        latitude: 27.7172,
        longitude: 85.3240,
        images: [],
        amenities: [],
        bedrooms: int.tryParse(_bedroomController.text) ?? 1,
        bathrooms: int.tryParse(_bathroomController.text) ?? 1,
        area: double.tryParse(_areaController.text) ?? 500,
        landlordId: 'current_landlord',
        status: _selectedStatus,  // 🔴 यहाँ available चयन भएको छ भनेर सुनिश्चित गर्नुहोस्
        createdAt: DateTime.now(),
      );
      
      // Provider मा कोठा थप्ने
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      await propertyProvider.addProperty(newProperty);
      
      setState(() {
        _isPosting = false;
      });
      
      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedStatus == PropertyStatus.available
                ? '✅ कोठा सफलतापूर्वक पोस्ट भयो! अब Home Screen मा देख्नुहोस्'
                : '⚠️ कोठा पोस्ट भयो तर "भाडामा" छ, Tenant ले देख्न पाउने छैन',
          ),
          backgroundColor: _selectedStatus == PropertyStatus.available ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Form खाली गर्ने
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _addressController.clear();
      _bedroomController.clear();
      _bathroomController.clear();
      _areaController.clear();
      
      // Previous page मा फर्किने
      Navigator.pop(context, true);
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _bedroomController.dispose();
    _bathroomController.dispose();
    _areaController.dispose();
    super.dispose();
  }
}