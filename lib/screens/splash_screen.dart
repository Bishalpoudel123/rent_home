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
              animation: _logoController,
              builder: (_, child) => Opacity(
                opacity:_logoOpacity.value,
                child:Transform.scale(
                   scale:_logoScale.value,
                   child: child,
                     ),
                    ),
                    child: Container(
                      width: 100,
                      height:100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2)
                blurRadius: 20,
                offset: const Offset(0,8),
              ),
            ],
          ),
          child:const Icon(
            Icons.home_rounded,
            size: 56,
            color: AppTheme.primaryRed,
          ),
        ),
      ),
       const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _textController,
                  builder: (_, child) => Opacity(
                    opacity: _textOpacity.value,
                    child: SlideTransition(
                      position: _textSlide,
                      child: child,
          ),
          ),
          child: Column(children: [
            const Text(
             'घर ढुन्डो',
             style:TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color:Colors.white,
              letterSpacing: 1, 
          ),
        ),
        const SizedBox(height: 8),
                      Text(
                        'नेपालको भरपर्दो घर खोज्ने ठाउँ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


      