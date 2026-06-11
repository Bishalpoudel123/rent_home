import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property_model.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';

class PostRoomScreen extends StatefulWidget {
  const PostRoomScreen({Key? key}) : super(key: key);

  @override
  State<PostRoomScreen> createState() => _PostRoomScreenState();
}

class _PostRoomScreenState extends State<PostRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Owner Personal Details
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  
  // Property Details
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _bedroomController = TextEditingController();
  final _bathroomController = TextEditingController();
  final _areaController = TextEditingController();
  
  bool _isPosting = false;
  PropertyStatus _selectedStatus = PropertyStatus.available;

  @override
  void initState() {
    super.initState();
    _loadOwnerData();
  }

  void _loadOwnerData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      _ownerNameController.text = user.name;
      _ownerEmailController.text = user.email;
    }
  }

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
            children: [
              // Owner Info
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(labelText: 'पुरा नाम *'),
                validator: (v) => v?.isEmpty ?? true ? 'नाम राख्नुहोस्' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ownerPhoneController,
                decoration: const InputDecoration(labelText: 'फोन नम्बर *'),
                validator: (v) => v?.isEmpty ?? true ? 'फोन राख्नुहोस्' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ownerEmailController,
                decoration: const InputDecoration(labelText: 'इमेल *'),
                validator: (v) => v?.isEmpty ?? true ? 'इमेल राख्नुहोस्' : null,
              ),
              const SizedBox(height: 20),
              
              // Property Info
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'कोठाको शीर्षक *'),
                validator: (v) => v?.isEmpty ?? true ? 'शीर्षक राख्नुहोस्' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'विवरण *'),
                validator: (v) => v?.isEmpty ?? true ? 'विवरण राख्नुहोस्' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'मासिक भाडा (रु.) *'),
                validator: (v) => v?.isEmpty ?? true ? 'मूल्य राख्नुहोस्' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'ठेगाना *'),
                validator: (v) => v?.isEmpty ?? true ? 'ठेगाना राख्नुहोस्' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bedroomController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'शयनकक्ष'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _bathroomController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'स्नानगृह'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'क्षेत्रफल (वर्ग फिट)'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isPosting ? null : _postProperty,
                child: _isPosting
                    ? const CircularProgressIndicator()
                    : const Text('कोठा पोस्ट गर्नुहोस्'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _postProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isPosting = true);
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
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
        landlordId: authProvider.currentUser?.id ?? 'landlord1',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
        ownerName: _ownerNameController.text,
        ownerPhone: _ownerPhoneController.text,
        ownerEmail: _ownerEmailController.text,
      );
      
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      await propertyProvider.addProperty(newProperty);
      
      setState(() => _isPosting = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ कोठा पोस्ट भयो!')),
      );
      
      Navigator.pop(context, true);
    }
  }
}