import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
  
  static const Map<String, String> _localizedStrings = {
    // Common
    'app_name': 'नेपाली होमरेन्ट',
    'welcome_back': 'पुन: स्वागत छ',
    'sign_in': 'साइन इन गर्नुहोस्',
    'sign_up': 'साइन अप गर्नुहोस्',
    'logout': 'लगआउट',
    'email': 'इमेल',
    'password': 'पासवर्ड',
    'confirm_password': 'पासवर्ड पुष्टि गर्नुहोस्',
    'full_name': 'पुरा नाम',
    'phone': 'फोन नम्बर',
    'forgot_password': 'पासवर्ड बिर्सनुभयो?',
    'no_account': 'खाता छैन?',
    'have_account': 'पहिले देखि खाता छ?',
    'next': 'अर्को',
    'get_started': 'सुरु गर्नुहोस्',
    'loading': 'लोड हुँदैछ...',
    'save': 'सेभ गर्नुहोस्',
    'cancel': 'रद्द गर्नुहोस्',
    'ok': 'ठीक छ',
    'error': 'त्रुटी',
    'login': 'लगइन',
    'register': 'रजिस्टर',
    
    // Home Screen
    'find_your_home': 'आफ्नो घर खोज्नुहोस्',
    'welcome': 'स्वागत छ',
    'find_perfect_room': 'आजै आफ्नो सही कोठा खोज्नुहोस्',
    'categories': 'श्रेणीहरू',
    'all': 'सबै',
    'apartment': 'अपार्टमेन्ट',
    'house': 'घर',
    'shared': 'साझा',
    'studio': 'स्टुडियो',
    
    // Property Detail
    'property_details': 'सम्पत्ति विवरण',
    'description': 'विवरण',
    'amenities': 'सुविधाहरू',
    'price_details': 'मूल्य विवरण',
    'monthly_rent': 'मासिक भाडा',
    'bedrooms': 'शयनकक्ष',
    'bathrooms': 'बाथरूम',
    'area': 'क्षेत्रफल',
    'available': 'उपलब्ध',
    'rented': 'भाडामा दिइसकियो',
    'message_landlord': 'घरधनीलाई सन्देश पठाउनुहोस्',
    'schedule_visit': 'भेटघाट तालिका बनाउनुहोस्',
    'send_message': 'सन्देश पठाउनुहोस्',
    'type_message': 'सन्देश लेख्नुहोस्...',
    
    // Search
    'search_properties': 'सम्पत्ति खोज्नुहोस्',
    'search_hint': 'शीर्षक वा ठेगाना खोज्नुहोस्...',
    'filter': 'फिल्टर',
    'price_range': 'मूल्य दायरा',
    'clear_filters': 'फिल्टर हटाउनुहोस्',
    'no_properties': 'कुनै सम्पत्ति फेला परेन',
    
    // Favorites
    'favorites': 'मनपर्नेहरू',
    'no_favorites': 'हाल कुनै मनपर्ने छैन',
    'start_adding': 'मनपर्नेमा सम्पत्ति थप्न सुरु गर्नुहोस्',
    'clear_favorites': 'सबै मनपर्ने हटाउनुहोस्',
    'clear_favorites_confirm': 'के तपाईं सबै मनपर्ने हटाउन निश्चित हुनुहुन्छ?',
    
    // Profile
    'profile': 'प्रोफाइल',
    'edit_profile': 'प्रोफाइल सम्पादन गर्नुहोस्',
    'notifications': 'सूचनाहरू',
    'privacy_security': 'गोपनीयता र सुरक्षा',
    'help_support': 'सहायता',
    'about': 'बारेमा',
    'version': 'संस्करण',
    'logout_confirm': 'के तपाईं लगआउट गर्न निश्चित हुनुहुन्छ?',
    
    // Chat
    'messages': 'सन्देशहरू',
    'no_messages': 'हाल कुनै सन्देश छैन',
    'today': 'आज',
    'yesterday': 'हिजो',
    
    // Roommate Finder
    'find_roommates': 'रूममेट खोज्नुहोस्',
    'age': 'उमेर',
    'occupation': 'पेशा',
    'budget': 'बजेट',
    'interests': 'रुचिहरू',
    'view_profile': 'प्रोफाइल हेर्नुहोस्',
    'connect': 'जडान गर्नुहोस्',
    
    // AI Assistant
    'ai_assistant': 'कृत्रिम बुद्धिमत्ता सहायक',
    'ask_anything': 'मलाई केही सोध्नुहोस्...',
    'ai_welcome': 'म तपाईंलाई सही कोठा खोज्न मद्दत गर्नको लागि यहाँ छु! तपाईं के खोज्दै हुनुहुन्छ?',
    
    // Post Room
    'post_room': 'नयाँ कोठा पोस्ट गर्नुहोस्',
    'title': 'शीर्षक',
    'address': 'ठेगाना',
    'price': 'मूल्य (प्रति महिना)',
    'post_property': 'सम्पत्ति पोस्ट गर्नुहोस्',
    'post_success': 'सम्पत्ति सफलतापूर्वक पोस्ट भयो!',
    
    // My Listings
    'my_listings': 'मेरो सूचीहरू',
    'no_listings': 'हाल कुनै सूची छैन',
    'tap_to_post': 'नयाँ सम्पत्ति पोस्ट गर्न + थिच्नुहोस्',
    
    'browse': 'ब्राउज गर्नुहोस्',
    'send': 'पठाउनुहोस्',
    'update': 'अपडेट गर्नुहोस्',
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'ne' || locale.languageCode == 'en';
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension StringTranslation on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}