import 'package:flutter/material.dart';
import 'package:nepal_rent_app/landlord/my_listings_screen.dart';
import 'package:nepal_rent_app/landlord/post_room_screen.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../tenant/ai_assistant_screen.dart';
import '../tenant/roommate_finder_screen.dart';
import '../landlord/post_room_screen.dart';
import '../landlord/my_listings_screen.dart';
import '../shared/conversations_screen.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    _setupScreens();
  }
  
  void _setupScreens() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLandlord = authProvider.currentUser?.userType == UserType.landlord;
    
    _screens = [
      HomeScreen(),
      SearchScreen(),
      isLandlord ? MyListingsScreen() : RoommateFinderScreen(),
      ConversationsScreen(),  // const हटाउनुहोस्
      ProfileScreen(),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLandlord = authProvider.currentUser?.userType == UserType.landlord;
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'घर',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'खोजी',
          ),
          BottomNavigationBarItem(
            icon: Icon(isLandlord ? Icons.list_alt : Icons.people),
            label: isLandlord ? 'मेरो सूची' : 'रूममेट',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'सन्देश',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'प्रोफाइल',
          ),
        ],
      ),
      floatingActionButton: isLandlord
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PostRoomScreen()),
                );
              },
              child: const Icon(Icons.add),
              tooltip: 'नयाँ कोठा पोस्ट गर्नुहोस्',
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AIAssistantScreen()),
                );
              },
              child: const Icon(Icons.assistant),
              tooltip: 'AI सहायक',
            ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('खोजी गर्नुहोस्'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'खोजी पृष्ठ',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'चाँडै आउँदैछ',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}