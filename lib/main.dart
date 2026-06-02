import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepal_rent_app/screens/favorites_screen.dart';
import 'package:nepal_rent_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:Colors.transparent
      statusBarIconBrightness: Brightness.dark,  
    ),
  );
  runApp(const KothakhojApp());
}







class KothakhojApp extends StatelessWidget {
  const KothakhojApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
           ChangeNotifierProvider(create: (_) => chatProvider()),
      ],
      child: MaterialApp(
        title: 'कोठा खोज - Nepal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightThem,
        home:const SplashScreen(),
      ),
  );
  }
}
