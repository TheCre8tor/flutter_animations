import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'circle_side.dart';

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
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) async {
    await Future.delayed(duration, this);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    /* pi = 3.14
     * pi = 180 degree
     * pi / 2 = 90 degree
     * */
    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(CurvedAnimation(
      parent: _counterClockwiseRotationController,
      curve: Curves.bounceOut,
    ));

    // flip animation ->
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.bounceOut,
    ));

    // status listeners ->
    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(CurvedAnimation(
          parent: _flipController,
          curve: Curves.bounceOut,
        ));

        // reset the flip controller and start the animation ->
        _flipController
          ..reset()
          ..forward();
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value + -(pi / 2),
        ).animate(CurvedAnimation(
          parent: _counterClockwiseRotationController,
          curve: Curves.bounceOut,
        ));

        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _counterClockwiseRotationAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateZ(_counterClockwiseRotationAnimation.value),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _flipAnimation,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()
                              ..rotateY(_flipAnimation.value),
                            child: ClipPath(
                              clipper: const HalfCircleClipper(
                                side: CircleSide.left,
                              ),
                              child: Container(
                                color: const Color(0xFF0057B7),
                                width: 100,
                                height: 100,
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _flipAnimation,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..rotateY(_flipAnimation.value),
                            child: ClipPath(
                              clipper: const HalfCircleClipper(
                                side: CircleSide.right,
                              ),
                              child: Container(
                                color: const Color(0xFFFFD700),
                                width: 100,
                                height: 100,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Animating only the circle")
          ],
        ),
      ),
    );
  }
}
