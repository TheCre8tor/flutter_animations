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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

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
    ).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
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
                      ClipPath(
                        clipper: const HalfCircleClipper(side: CircleSide.left),
                        child: Container(
                          color: const Color(0xFF0057B7),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      ClipPath(
                        clipper:
                            const HalfCircleClipper(side: CircleSide.right),
                        child: Container(
                          color: const Color(0xFFFFD700),
                          width: 100,
                          height: 100,
                        ),
                      )
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
