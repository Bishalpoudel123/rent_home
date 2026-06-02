import 'package:flutter/material.dart';
import 'package:nepal_rent_app/services/gemini_services.dart';
//import '../../services/gemini_service.dart';
import '../../services/mock_data_service.dart';
import '../../utils/app_theme.dart';

class PostRoomScreen extends StatefulWidget {
  const PostRoomScreen({super.key});

  @override
  State<PostRoomScreen> createState() => _PostRoomScreenState();
}

class _PostRoomScreenState extends State<PostRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  String _selectedType = '1BHK';
  String _selectedDistrict = 'काठमाडौँ';
  String _furnishing = 'unfurnished';
  final List<String> _selectedFacilities = [];
  bool _isGeneratingDesc = false;
  bool _isSuggestingPrice = false;
  bool _isPosting = false;
  int _currentStep = 0;

  final List<String> _roomTypes = [
    '1BHK', '2BHK', '3BHK', 'flat', 'hostel', 'PG', 'office'
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    _priceCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _generateDescription() async {
    if (_areaCtrl.text.isEmpty) {
      _showSnack('पहिले ठेगाना भर्नुहोस्');
      return;
    }
    setState(() => _isGeneratingDesc = true);
    final desc = await GeminiService.generateRoomDescription(
      type: _selectedType,
      area: _areaCtrl.text,
      price: int.tryParse(_priceCtrl.text) ?? 0,
      facilities: _selectedFacilities,
    );
    if (desc.isNotEmpty) _descCtrl.text = desc;
    setState(() => _isGeneratingDesc = false);
  }

  Future<void> _suggestPrice() async {
    if (_areaCtrl.text.isEmpty) {
      _showSnack('पहिले ठेगाना भर्नुहोस्');
      return;
    }
    setState(() => _isSuggestingPrice = true);
    final price = await GeminiService.suggestPrice(
      type: _selectedType,
      area: _areaCtrl.text,
      facilities: _selectedFacilities,
    );
    if (price.isNotEmpty) {
      _showSnack('AI सुझाव: $price');
    }
    setState(() => _isSuggestingPrice = false);
  }

  Future<void> _postRoom() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isPosting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isPosting = false);
    if (mounted) {
      Navigator.pop(context);
      _showSnack('कोठा post भयो! ✅');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('नयाँ कोठा थप्नुहोस्')),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) setState(() => _currentStep++);
            else _postRoom();
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          controlsBuilder: (_, details) => Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _isPosting ? null : details.onStepContinue,
                  child: _isPosting
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(_currentStep == 2 ? 'Post गर्नुहोस्' : 'अर्को'),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('पछाडि')),
                ],
              ],
            ),
          ),
          steps: [
            Step(
              title: const Text('आधारभूत जानकारी'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _buildStep1(),
            ),
            Step(
              title: const Text('विवरण र मूल्य'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildStep2(),
            ),
            Step(
              title: const Text('सुविधाहरू'),
              isActive: _currentStep >= 2,
              content: _buildStep3(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    final districts = MockDataService.getNepalDistricts();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Room type
        const Text('कोठाको प्रकार',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _roomTypes.map((t) => GestureDetector(
            onTap: () => setState(() => _selectedType = t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedType == t
                    ? AppTheme.primaryRed
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(t,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _selectedType == t
                          ? Colors.white
                          : AppTheme.textGrey)),
            ),
          )).toList(),
        ),
        const SizedBox(height: 16),

        // Title
        const Text('शीर्षक',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _titleCtrl,
          decoration: const InputDecoration(hintText: 'जस्तै: 2BHK Flat in Koteshwor'),
          validator: (v) => v!.isEmpty ? 'शीर्षक राख्नुहोस्' : null,
        ),
        const SizedBox(height: 16),

        // District
        const Text('जिल्ला',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedDistrict,
          decoration: const InputDecoration(),
          items: districts.map((d) =>
              DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: (v) => setState(() => _selectedDistrict = v!),
        ),
        const SizedBox(height: 16),

        // Address
        const Text('ठेगाना',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _areaCtrl,
          decoration: const InputDecoration(hintText: 'Koteshwor, Kathmandu'),
          validator: (v) => v!.isEmpty ? 'ठेगाना राख्नुहोस्' : null,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price row
        Row(
          children: [
            const Expanded(
              child: Text('मासिक भाडा (NPR)',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
            ),
            GestureDetector(
              onTap: _suggestPrice,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isSuggestingPrice
                    ? const SizedBox(
                        width: 12, height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 12, color: AppTheme.primaryBlue),
                          SizedBox(width: 4),
                          Text('AI सुझाव',
                              style: TextStyle(fontSize: 11, color: AppTheme.primaryBlue)),
                        ],
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _priceCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: '15000',
            prefixText: 'रू ',
          ),
          validator: (v) => v!.isEmpty ? 'मूल्य राख्नुहोस्' : null,
        ),
        const SizedBox(height: 16),

        // Furnishing
        const Text('फर्निचर अवस्था',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        const SizedBox(height: 8),
        Row(
          children: [
            _FurnishChip(label: 'सबै छ', value: 'furnished', selected: _furnishing, onTap: (v) => setState(() => _furnishing = v)),
            const SizedBox(width: 8),
            _FurnishChip(label: 'केही छ', value: 'semi-furnished', selected: _furnishing, onTap: (v) => setState(() => _furnishing = v)),
            const SizedBox(width: 8),
            _FurnishChip(label: 'छैन', value: 'unfurnished', selected: _furnishing, onTap: (v) => setState(() => _furnishing = v)),
          ],
        ),
        const SizedBox(height: 16),

        // Description
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('विवरण',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
            GestureDetector(
              onTap: _generateDescription,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isGeneratingDesc
                    ? const SizedBox(
                        width: 12, height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryRed))
                    : const Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 12, color: AppTheme.primaryRed),
                          SizedBox(width: 4),
                          Text('AI ले लेखोस्',
                              style: TextStyle(fontSize: 11, color: AppTheme.primaryRed)),
                        ],
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _descCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
              hintText: 'कोठाको बारेमा लेख्नुहोस्...'),
          validator: (v) => v!.isEmpty ? 'विवरण राख्नुहोस्' : null,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final amenities = MockDataService.getAmenities();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('उपलब्ध सुविधाहरू चयन गर्नुहोस्',
            style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenities.map((a) {
            final selected = _selectedFacilities.contains(a);
            return GestureDetector(
              onTap: () => setState(() {
                selected
                    ? _selectedFacilities.remove(a)
                    : _selectedFacilities.add(a);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.primaryRed.withOpacity(0.1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: selected
                          ? AppTheme.primaryRed
                          : Colors.transparent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selected)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.check, size: 12, color: AppTheme.primaryRed),
                      ),
                    Text(a,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: selected
                                ? AppTheme.primaryRed
                                : AppTheme.textGrey)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FurnishChip extends StatelessWidget {
  final String label, value, selected;
  final Function(String) onTap;
  const _FurnishChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryRed : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textGrey)),
      ),
    );
  }
}