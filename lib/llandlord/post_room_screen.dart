import 'package:flutter/material.dart';
import 'package:nepal_rent_app/services/gemini_services.dart';

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
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _areaController = TextEditingController();

  String _selectedType = "Room";

  List<String> _selectedAmenities = [];

  final List<String> _availableAmenities = [
    'WiFi',
    'AC',
    'Parking',
    'Furnished',
    'Gym',
    'Laundry',
    'Pet Friendly'
  ];

  bool _loadingAI = false;

  Future<void> _generateWithAI() async {
    setState(() => _loadingAI = true);

    final desc = await GeminiService.generateRoomDescription(
      roomType: _selectedType,
      location: _addressController.text,
      amenities: _selectedAmenities.join(", "),
    );

    final price = await GeminiService.suggestPrice(
      roomType: _selectedType,
      location: _addressController.text,
    );

    setState(() {
      _descriptionController.text = desc;
      _priceController.text = price.toString();
      _loadingAI = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post New Room'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Description'),
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),

              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ["Room", "Apartment", "Studio"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedType = val!;
                  });
                },
                decoration: InputDecoration(labelText: "Type"),
              ),

              SizedBox(height: 20),

              Text(
                "Amenities",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              Wrap(
                children: _availableAmenities.map((amenity) {
                  final selected = _selectedAmenities.contains(amenity);

                  return FilterChip(
                    label: Text(amenity),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedAmenities.add(amenity);
                        } else {
                          _selectedAmenities.remove(amenity);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _loadingAI ? null : _generateWithAI,
                icon: _loadingAI
                    ? CircularProgressIndicator(color: Colors.white)
                    : Icon(Icons.auto_awesome),
                label: Text("Generate with AI"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Property Posted")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text("Post Property"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    super.dispose();
  }
}