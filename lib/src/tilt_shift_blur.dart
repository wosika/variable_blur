import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:variable_blur/src/models/blur_side.dart';

class VariableBlur extends StatelessWidget {
  const VariableBlur({
    super.key,
    required this.child,
    required this.sigma,
    required this.blurSides, // Replaces focusHeight and axis
  });

  final Widget child;
  final double sigma;
  final BlurSides blurSides; // Configure extents for each side

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, shader, _) {
      return AnimatedSampler((image, size, canvas) {
        // Pass all four extents to the shader
        shader
          ..setFloat(0, size.width) // uViewSize.x
          ..setFloat(1, size.height) // uViewSize.y
          ..setFloat(2, sigma) // sigma
          ..setFloat(3, blurSides.top)
          ..setFloat(4, blurSides.bottom)
          ..setFloat(5, blurSides.left)
          ..setFloat(6, blurSides.right);

        shader.setImageSampler(0, image); // uTexture
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..shader = shader,
        );
      }, child: child);
    }, assetKey: 'packages/variable_blur/shaders/tilt_shift_gaussian.frag');
  }
}
