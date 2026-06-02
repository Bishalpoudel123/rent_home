import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../main_navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  UserRole _selectedRole = UserRole.tenant;
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
      password: _passCtrl.text,
      role: _selectedRole,
    );
    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('नयाँ खाता')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'खाता खोल्नुहोस्',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark),
              ),
              const SizedBox(height: 8),
              const Text('सबै जानकारी सही भर्नुहोस्',
                  style: TextStyle(color: AppTheme.textGrey)),
              const SizedBox(height: 32),

              // Role selection
              const Text('म के हुँ?',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _RoleChip(
                    label: 'किरायामा लिनेले',
                    icon: Icons.person,
                    selected: _selectedRole == UserRole.tenant,
                    onTap: () => setState(() => _selectedRole = UserRole.tenant),
                  ),
                  const SizedBox(width: 12),
                  _RoleChip(
                    label: 'घर मालिक',
                    icon: Icons.house,
                    selected: _selectedRole == UserRole.landlord,
                    onTap: () =>
                        setState(() => _selectedRole = UserRole.landlord),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildField('पूरा नाम', _nameCtrl, Icons.person_outline,
                  'नाम राख्नुहोस्', false),
              const SizedBox(height: 16),
              _buildField('इमेल', _emailCtrl, Icons.email_outlined,
                  'email@example.com', false,
                  type: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildField('मोबाइल नम्बर', _phoneCtrl, Icons.phone_outlined,
                  '98XXXXXXXX', false,
                  type: TextInputType.phone),
              const SizedBox(height: 16),

              const Text('पासवर्ड',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                      fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon:
                        Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) =>
                    v!.length < 6 ? 'कम्तिमा ६ अक्षर चाहिन्छ' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _register,
                  child: auth.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('दर्ता गर्नुहोस्'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      IconData icon, String hint, bool obscure,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
                fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
          validator: (v) => v!.isEmpty ? '$label राख्नुहोस्' : null,
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primaryRed.withOpacity(0.1)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.primaryRed : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color:
                      selected ? AppTheme.primaryRed : AppTheme.textGrey),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      selected ? AppTheme.primaryRed : AppTheme.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}