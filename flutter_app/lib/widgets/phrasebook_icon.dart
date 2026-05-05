import 'package:flutter/material.dart';

class PhrasebookIcon extends StatelessWidget {
  const PhrasebookIcon({super.key, this.size = 28, this.semanticLabel});

  final double size;
  final String? semanticLabel;

  static const String assetPath =
      'assets/images/icons/japanese_phrasebook_icon.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: semanticLabel,
    );
  }
}
