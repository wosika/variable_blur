import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class VariableBlur extends StatelessWidget {
  const VariableBlur({
    super.key,
    required this.child,
    required this.progress,
    required this.blurArea, // Extent + direction (positive/negative)
    required this.axis, // Axis.vertical or Axis.horizontal
  });

  final Widget child;
  final double progress;
  final double blurArea;
  final Axis axis; // Determines blur direction (vertical/horizontal)

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, shader, _) {
      return AnimatedSampler((image, size, canvas) {
        shader.setFloat(0, size.width); // uViewSize.x
        shader.setFloat(1, size.height); // uViewSize.y
        shader.setFloat(2, progress); // sigma
        shader.setFloat(3, blurArea); // blurHeight (extent + direction)
        shader.setFloat(4, axis == Axis.horizontal ? 1.0 : 0.0); // blurAxis

        shader.setImageSampler(0, image); // uTexture
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..shader = shader,
        );
      }, child: child);
    }, assetKey: 'packages/variable_blur/shaders/tilt_shift_gaussian.frag');
  }
}
