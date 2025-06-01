/// Defines the blur intensity for different sides/regions of a widget.
///
/// The [BlurSides] class allows you to specify different blur intensities
/// for the top, bottom, left, and right regions of a widget. Values range
/// from 0.0 (no blur) to 1.0 (maximum blur).
///
/// ## Example Usage
///
/// ```dart
/// // Create vertical blur effect
/// final verticalBlur = BlurSides.vertical(top: 1.0, bottom: 0.3);
///
/// // Create horizontal blur effect
/// final horizontalBlur = BlurSides.horizontal(left: 0.8, right: 0.2);
/// ```
class BlurSides {
  /// The blur intensity for the top region (0.0 to 1.0).
  final double top;

  /// The blur intensity for the bottom region (0.0 to 1.0).
  final double bottom;

  /// The blur intensity for the left region (0.0 to 1.0).
  final double left;

  /// The blur intensity for the right region (0.0 to 1.0).
  final double right;

  const BlurSides._({
    this.top = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
  });

  /// Creates a horizontal blur effect with specified left and right intensities.
  ///
  /// This constructor is useful for creating blur effects that transition
  /// from left to right or vice versa.
  ///
  /// Example:
  /// ```dart
  /// final blur = BlurSides.horizontal(left: 1.0, right: 0.0);
  /// ```
  ///
  /// [left] - The blur intensity for the left region (default: 0.0)
  /// [right] - The blur intensity for the right region (default: 0.0)
  const BlurSides.horizontal({double left = 0.0, double right = 0.0})
      : this._(left: left, right: right);

  /// Creates a vertical blur effect with specified top and bottom intensities.
  ///
  /// This constructor is perfect for creating tilt-shift photography effects
  /// or focus transitions from top to bottom.
  ///
  /// Example:
  /// ```dart
  /// final blur = BlurSides.vertical(top: 0.8, bottom: 0.2);
  /// ```
  ///
  /// [top] - The blur intensity for the top region (default: 0.0)
  /// [bottom] - The blur intensity for the bottom region (default: 0.0)
  const BlurSides.vertical({double top = 0.0, double bottom = 0.0})
      : this._(top: top, bottom: bottom);
}
