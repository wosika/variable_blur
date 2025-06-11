import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:variable_blur/src/models/blur_side.dart';

/// A widget that applies variable blur effects to its child widget.
///
/// [VariableBlur] enables you to create sophisticated blur effects with different
/// intensities for different regions of the widget. It's perfect for creating
/// tilt-shift photography effects, focus transitions, or artistic blur overlays.
///
/// The widget uses GPU-accelerated Fragment Shaders for high-performance rendering
/// and supports customizable blur regions, quality settings, and smooth edge transitions.
///
/// ## Key Features
/// - Variable blur intensity across different regions
/// - Smooth edge transitions with customizable intensity
/// - High-performance GPU-accelerated rendering
/// - Quality control for performance optimization
/// - Android device compatibility support
///
/// ## Important Compatibility Note
/// **Blur effects only work on images or colored containers.** The child widget must have
/// visible content (pixels) for the blur effect to be applied. Transparent widgets,
/// empty containers, or widgets without background colors will not show blur effects.
///
/// Supported child widgets include:
/// - `Image` widgets (network, asset, file, memory)
/// - `Container` with background color or decoration
/// - Widgets with colored backgrounds
/// - Custom painted widgets with visible content
///
/// For comprehensive usage examples, please refer to the example app.
///
/// ## Example Usage
///
/// ```dart
/// VariableBlur(
///   sigma: 15.0,
///   blurSides: BlurSides.vertical(top: 1.0, bottom: 0.3),
///   edgeIntensity: 0.2,
///   kernelSize: 20.0,
///   quality: BlurQuality.high,
///   child: Image.asset('assets/photo.jpg'),
/// )
/// ```
///
/// ## Performance Considerations
/// - Use [BlurQuality.low] or [BlurQuality.medium] for better performance on lower-end devices
/// - Higher [sigma] values require more processing power
/// - Higher [kernelSize] values create smoother blur but impact performance
/// - The [edgeIntensity] affects the smoothness of blur transitions
class VariableBlur extends StatelessWidget {
  /// Creates a [VariableBlur] widget.
  ///
  /// The [child], [sigma], and [blurSides] parameters are required.
  ///
  /// [sigma] controls the overall blur intensity and must be greater than 0.
  /// [blurSides] defines the blur intensity for different regions.
  /// [quality] controls the rendering quality vs performance trade-off.
  /// [edgeIntensity] controls the smoothness of blur transitions (0.0 to 1.0).
  /// [kernelSize] controls the blur kernel size (higher = more blur samples).
  ///
  /// [isYFlipNeed] should be set to true on Android devices that flip the Y-axis.
  const VariableBlur(
      {super.key,
      required this.child,
      required this.sigma,
      required this.blurSides,
      this.quality = BlurQuality.high, // Add quality control
      this.edgeIntensity = 0.15, // 15% of screen size for smooth transition
      this.kernelSize = 25, // Default kernel size
      this.isYFlipNeed = false});

  /// The widget to apply the blur effect to.
  final Widget child;

  /// The blur intensity/radius in logical pixels.
  ///
  /// Higher values create stronger blur effects. Must be greater than 0.
  /// Typical values range from 1.0 to 50.0, though larger values are supported.
  final double sigma;

  /// Defines the blur intensity for different regions of the widget.
  ///
  /// Use [BlurSides.vertical] for top-to-bottom blur transitions,
  /// [BlurSides.horizontal] for left-to-right transitions,
  ///
  final BlurSides blurSides;

  /// Controls the rendering quality vs performance trade-off.
  ///
  /// - [BlurQuality.high]: Best quality, slower performance
  /// - [BlurQuality.medium]: Balanced quality and performance
  /// - [BlurQuality.low]: Fastest performance, lower quality
  final BlurQuality quality;

  /// Controls the intensity of smooth edge transitions (0.0 to 1.0).
  ///
  /// Higher values create smoother, more gradual transitions between
  /// blurred and non-blurred regions. Lower values create sharper transitions.
  /// Default is 0.15 (15% of the screen size).
  final double edgeIntensity;

  /// Controls the blur kernel size (number of samples).
  ///
  /// Higher values create smoother blur effects but require more processing power.
  /// Lower values are faster but may produce less smooth results.
  /// Typical values range from 5.0 to 25.0.
  /// Default is 15.0.
  final double kernelSize;

  /// Whether to flip the Y-axis coordinate system.
  ///
  /// Some Android devices use different coordinate systems that can cause
  /// the blur effect to appear flipped. Set this to true if the blur effect
  /// appears vertically flipped on the target device.
  ///
  /// This is typically only needed on specific Android devices and should
  /// be false for most use cases.
  final bool isYFlipNeed;

  @override
  Widget build(BuildContext context) {
    if (sigma <= 0) {
      return child;
    }

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
            ..setFloat(7, !isYFlipNeed ? 0.0 : 1.0)
            ..setFloat(8, edgeIntensity)
            ..setFloat(9, _getAdjustedKernelSize());

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
      ..setFloat(2, _getAdjustedSigma()) // Use original sigma, not adjusted
      ..setFloat(3, blurSides.top)
      ..setFloat(4, blurSides.bottom)
      ..setFloat(5, blurSides.left)
      ..setFloat(6, blurSides.right)
      ..setFloat(7, !isYFlipNeed ? 0.0 : 1.0)
      ..setFloat(8, _getAdjustedKernelSize());

    shader.setImageSampler(0, image);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );

    return recorder.endRecording();
  }

  double _getAdjustedSigma() {
    // For large sigma values, quality adjustment should be minimal
    // to preserve the blur effect
    switch (quality) {
      case BlurQuality.low:
        return sigma > 10
            ? sigma * 0.8
            : sigma * 0.5; // Less reduction for large sigma
      case BlurQuality.medium:
        return sigma > 10 ? sigma * 0.9 : sigma * 0.75;
      case BlurQuality.high:
        return sigma;
    }
  }

  double _getAdjustedKernelSize() {
    // Adjust kernel size based on quality setting
    switch (quality) {
      case BlurQuality.low:
        return (kernelSize * 0.6).clamp(3.0, 25.0);
      case BlurQuality.medium:
        return (kernelSize * 0.8).clamp(5.0, 50.0);
      case BlurQuality.high:
        return kernelSize;
    }
  }
}

/// Defines the rendering quality levels for blur effects.
///
/// Different quality levels provide a trade-off between visual quality
/// and performance. Choose the appropriate level based on your target
/// devices and performance requirements.
///
/// ## Quality Levels
/// - [low]: Fastest rendering, suitable for real-time animations or lower-end devices
/// - [medium]: Balanced quality and performance for most use cases
/// - [high]: Best visual quality, recommended for static images or high-end devices
enum BlurQuality {
  /// Fastest rendering with reduced quality.
  ///
  /// Recommended for:
  /// - Real-time blur animations
  /// - Lower-end devices
  /// - Cases where performance is critical
  low,

  /// Balanced quality and performance.
  ///
  /// Recommended for:
  /// - Most general use cases
  /// - Mid-range devices
  /// - Interactive blur effects
  medium,

  /// Highest quality rendering.
  ///
  /// Recommended for:
  /// - Static images with blur effects
  /// - High-end devices
  /// - Cases where visual quality is paramount
  high
}
