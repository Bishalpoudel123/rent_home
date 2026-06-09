import 'package:flutter/material.dart';
import 'package:nepal_rent_app/llandlord/my_listings_screen.dart';
import 'package:nepal_rent_app/llandlord/post_room_screen.dart';
import 'package:nepal_rent_app/models/user_model.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../tenant/ai_assistant_screen.dart';
import '../tenant/roommate_finder_screen.dart';
//import '../landlord/post_room_screen.dart';
//import '../landlord/my_listings_screen.dart';
import '../shared/conversations_screen.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
      ConversationsScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(isLandlord ? Icons.list_alt : Icons.people),
            label: isLandlord ? 'My Listings' : 'Roommates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
              child: Icon(Icons.add),
              tooltip: 'Post New Room',
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AIAssistantScreen()),
                );
              },
              child: Icon(Icons.assistant),
              tooltip: 'AI Assistant',
            ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Properties'),
      ),
      body: Center(
        child: Text('Search Screen - Coming Soon'),
      ),
    );
  }
}