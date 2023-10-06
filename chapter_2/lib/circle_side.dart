import 'package:flutter/material.dart';

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool isClockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0); // move the origin to top right
        offset = Offset(size.width, size.height);
        isClockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        isClockwise = true;
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2), // center
      clockwise: isClockwise,
    );

    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
