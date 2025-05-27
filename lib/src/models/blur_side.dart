class BlurSides {
  final double top;
  final double bottom;
  final double left;
  final double right;

  const BlurSides._({
    this.top = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
  });

  const BlurSides.horizontal({double left = 0.0, double right = 0.0})
      : this._(left: left, right: right);

  const BlurSides.vertical({double top = 0.0, double bottom = 0.0})
      : this._(top: top, bottom: bottom);
}
