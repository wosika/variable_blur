import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:variable_blur/src/models/blur_side.dart';

class VariableBlur extends StatelessWidget {
  const VariableBlur({
    super.key,
    required this.child,
    required this.sigma,
    required this.blurSides,
    this.blurTint = const Color(0xFFFFFFFF),
  });

  final Widget child;
  final double sigma;
  final BlurSides blurSides;
  final Color blurTint;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, horizontalShader, _) {
      return ShaderBuilder((context, verticalShader, _) {
        return AnimatedSampler((image, size, canvas) {
          // Create intermediate render target for horizontal pass
          final ui.Picture horizontalPicture =
              _createHorizontalPass(horizontalShader, image, size);
          final ui.Image horizontalImage = horizontalPicture.toImageSync(
              size.width.toInt(), size.height.toInt());

          // Vertical pass with final blending
          verticalShader
            ..setFloat(0, size.width)
            ..setFloat(1, size.height)
            ..setFloat(2, sigma)
            ..setFloat(3, blurSides.top)
            ..setFloat(4, blurSides.bottom)
            ..setFloat(5, blurSides.left)
            ..setFloat(6, blurSides.right)
            ..setFloat(7, blurTint.r)
            ..setFloat(8, blurTint.g)
            ..setFloat(9, blurTint.b)
            ..setFloat(10, blurTint.a);

          verticalShader.setImageSampler(0, horizontalImage);
          verticalShader.setImageSampler(1, image); // Original for blending

          canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Paint()..shader = verticalShader,
          );

          horizontalImage.dispose();
        }, child: child);
      }, assetKey: 'packages/variable_blur/shaders/tilt_shift_vertical.frag');
    }, assetKey: 'packages/variable_blur/shaders/tilt_shift_horizontal.frag');
  }

  ui.Picture _createHorizontalPass(
      ui.FragmentShader shader, ui.Image image, Size size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, sigma)
      ..setFloat(3, blurSides.top)
      ..setFloat(4, blurSides.bottom)
      ..setFloat(5, blurSides.left)
      ..setFloat(6, blurSides.right);

    shader.setImageSampler(0, image);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );

    return recorder.endRecording();
  }
}
