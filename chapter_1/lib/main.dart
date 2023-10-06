import 'dart:math' show pi;

import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Tween means an animation that is between two things
    _animation = Tween<double>(
      begin: 0.0,
      end: pi * 2.0,
      // a pi is equal 180 degree
      // two pi is equal 360 degree
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /* animation_controller  -    animation
   * 0.0                   =    0 degrees
   * 0.5                   =    180 degrees
   * 1.0                   =    360 degrees
   * */

  /* NOTE:
   * vsync also know as Vertical Sync, comes down to refreshing the screen and
   * how object hang together.
   * HomePage is a widget, it is drawn on the screen at the refresh rate
   * of your screen. Most screens this days are 60Harts, which means that they
   * refresh their content 60 times per seconds.
   * */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Transform(
              // alignment: Alignment.center,
              origin: const Offset(50, 50),
              // only use origin if you have a specific origin that's
              // not part of alignment specification
              //
              // ------------
              //
              // transform rotate clockwise because the canvas is
              // flipped on the X axis.

              // Matrix4.identity is same as Offset.zero
              // It also means no rotation, no translation, just
              // reset the matrix.
              transform: Matrix4.identity()..rotateZ(_animation.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
