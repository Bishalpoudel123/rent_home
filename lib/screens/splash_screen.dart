import 'package:flutter/material.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  state<SplashScreen> createState() =>_SplashScreenState();
}
  
   class_SplashScreenState extends State<SplashScreen>
     with TickerProviderStateMixin {
      late AnimationController _logoController;
      late AnimationController _textContainer;
      late AnimationController _logoScale;
      late AnimationController _logoOpacity;
      late Animation<double> _textOpacity;
       late Animation<Offset> _textSlide;
       
       @override
       Void initState() {
        super.Instate();
        _logicController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1000),
        );
         _textController =AnimationController(
          vsync: this,
         duration: const Duration(milliseconds: 800),
         );
        
         _logoScale = Tween<double>(begin: 0.5, end:1.0).animate(
          CurvedAnimation(parent: _logoController,curve: :curves.elasticOut),
         ); 
           _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _startAnimation(); 
     }

     void_startAnimation() async {
      await Future.delayed(const Duration (milliseconds: 300));
      _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
     }

     @ override
       void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient:LinearGradient(
          begin: Allignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryRed,color(0xFF8B0000)],
         ),
         ),
         child: SafeArea(
          child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              
            )
          ],
          ),
         ))







      ),
    )
  )
}


      