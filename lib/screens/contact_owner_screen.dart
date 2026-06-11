import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactOwnerScreen extends StatelessWidget {
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final String propertyTitle;

  const ContactOwnerScreen({
    Key? key,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.propertyTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'घरधनीलाई सम्पर्क गर्नुहोस्',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'कोठाको जानकारी',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    propertyTitle,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Owner Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Owner Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        ownerName.isNotEmpty ? ownerName[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Owner Name
                  Text(
                    ownerName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'घरधनी',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 20),
                  
                  // Contact Options Title
                  const Text(
                    'सम्पर्क विकल्पहरू',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Phone Call Option
                  _buildContactOption(
                    context,
                    icon: Icons.phone,
                    title: 'फोन गर्नुहोस्',
                    subtitle: ownerPhone,
                    color: Colors.green,
                    onTap: () => _makePhoneCall(context, ownerPhone),
                  ),
                  
                  // SMS Option
                  _buildContactOption(
                    context,
                    icon: Icons.message,
                    title: 'एसएमएस पठाउनुहोस्',
                    subtitle: ownerPhone,
                    color: Colors.blue,
                    onTap: () => _sendSMS(context, ownerPhone),
                  ),
                  
                  // Email Option
                  _buildContactOption(
                    context,
                    icon: Icons.email,
                    title: 'इमेल पठाउनुहोस्',
                    subtitle: ownerEmail,
                    color: Colors.red,
                    onTap: () => _sendEmail(context, ownerEmail),
                  ),
                  
                  // WhatsApp Option
                  _buildContactOption(
                    context,
                    icon: Icons.chat,
                    title: 'WhatsApp',
                    subtitle: ownerPhone,
                    color: Colors.green.shade700,
                    onTap: () => _openWhatsApp(context, ownerPhone),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tips Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.lightbulb, color: Colors.orange.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'सुझाव',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'घरधनीलाई सम्पर्क गर्दा कृपया नम्र भाषा प्रयोग गर्नुहोस्। कोठाको बारेमा स्पष्ट जानकारी लिनुहोस्।',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Message Template Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_quote, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'सन्देश टेम्पलेट',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'नमस्ते $ownerName जी,',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'म तपाईंको कोठा "$propertyTitle" हेर्न चाहन्छु। कृपया मलाई भेटघाटको समय र मिति बताउनुहोस्।',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'धन्यवाद',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final message = 'नमस्ते $ownerName जी,\n\nम तपाईंको कोठा "$propertyTitle" हेर्न चाहन्छु। कृपया मलाई भेटघाटको समय र मिति बताउनुहोस्।\n\nधन्यवाद';
                        _copyToClipboard(context, message);
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('टेम्पलेट कपि गर्नुहोस्'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      _showError(context, 'फोन नम्बर उपलब्ध छैन');
      return;
    }
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'फोन गर्न सकिएन';
      }
    } catch (e) {
      _showError(context, 'फोन गर्न सकिएन');
    }
  }

  Future<void> _sendSMS(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      _showError(context, 'फोन नम्बर उपलब्ध छैन');
      return;
    }
    final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'एसएमएस पठाउन सकिएन';
      }
    } catch (e) {
      _showError(context, 'एसएमएस पठाउन सकिएन');
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    if (email.isEmpty) {
      _showError(context, 'इमेल उपलब्ध छैन');
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=कोठाको बारेमा जानकारी चाहियो&body=नमस्ते, म तपाईंको कोठा "$propertyTitle" को बारेमा जानकारी लिन चाहन्छु।',
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'इमेल पठाउन सकिएन';
      }
    } catch (e) {
      _showError(context, 'इमेल पठाउन सकिएन');
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      _showError(context, 'फोन नम्बर उपलब्ध छैन');
      return;
    }
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri launchUri = Uri(scheme: 'https', path: 'wa.me/$cleanNumber');
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'WhatsApp खोल्न सकिएन';
      }
    } catch (e) {
      _showError(context, 'WhatsApp खोल्न सकिएन');
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ टेम्पलेट कपि गरियो'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}