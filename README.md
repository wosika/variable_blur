# Variable Blur

A Flutter package that provides customizable blur effects including tilt-shift blur for creating depth-of-field and variable blur effects in your Flutter applications.

## Screenshots

| Example 1 | Example 2 | Example 3 (blur with scroll) |
|-------------------|-----------------|---------------|
| ![Dynamic](screen_shots/4.png) | ![Horizontal](screen_shots/2.png) | ![Vertical](screen_shots/3.png) |

| Example 4 (Blurred Header) | Performance comparison |
|-------------------|----------------|
| ![Quality](screen_shots/5.png) | ![Custom](screen_shots/6.png) |

## Features

- **Variable Blur Effects**: Apply blur effects with different intensities on different sides of a widget
- **Tilt-Shift Blur**: Create professional depth-of-field effects similar to tilt-shift photography
- **Customizable Blur Sides**: Control blur intensity independently on top, bottom, left, and right sides
- **Performance Optimized**: Uses GPU shaders for smooth, high-performance blur rendering
- **Color Tinting**: Add custom color tints to blur effects
- **Quality Control**: Adjustable quality settings for performance optimization

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  variable_blur: ^0.0.1
```

Then run:

```bash
flutter pub get
```

Import the package in your Dart code:

```dart
import 'package:variable_blur/variable_blur.dart';
```

## Usage

### Basic Variable Blur

Wrap any widget with `VariableBlur` to apply customizable blur effects:

```dart
VariableBlur(
  sigma: 5.0,
  blurSides: BlurSides.horizontal(left: 1.0, right: 1.0),
  child: Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/your_image.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  ),
)
```

### Tilt-Shift Photography Effect

Create a tilt-shift blur effect for depth-of-field photography:

```dart
VariableBlur(
  sigma: 8.0,
  blurSides: BlurSides.vertical(top: 1.0, bottom: 1.0),
  quality: BlurQuality.high,
  child: Image.asset('assets/landscape.jpg'),
)
```

### Dynamic Scroll-Based Blur

Create dynamic blur effects that respond to user interactions:

```dart
class ScrollBlurExample extends StatefulWidget {
  @override
  _ScrollBlurExampleState createState() => _ScrollBlurExampleState();
}

class _ScrollBlurExampleState extends State<ScrollBlurExample> {
  double blurSigma = 0.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    const maxBlur = 8.0;
    const scrollThreshold = 200.0;

    setState(() {
      blurSigma = maxBlur * (_scrollController.offset / scrollThreshold).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          flexibleSpace: VariableBlur(
            sigma: blurSigma,
            blurSides: BlurSides.vertical(bottom: 1.0),
            child: FlexibleSpaceBar(
              background: Image.asset('assets/header_image.jpg', fit: BoxFit.cover),
            ),
          ),
        ),
        // Your scrollable content here
      ],
    );
  }
}
```

### Blur Sides Configuration

Control blur intensity on different sides:

```dart
// Horizontal blur only
BlurSides.horizontal(left: 0.5, right: 0.8)

// Vertical blur only
BlurSides.vertical(top: 1.0, bottom: 0.3)

// Custom configuration for all sides
BlurSides._(top: 0.2, bottom: 0.8, left: 0.0, right: 1.0)
```

## API Reference

### VariableBlur

The main widget for applying variable blur effects.

| Parameter   | Type          | Default            | Description                                            |
| ----------- | ------------- | ------------------ | ------------------------------------------------------ |
| `child`     | `Widget`      | required           | The widget to apply blur effects to                    |
| `sigma`     | `double`      | required           | The blur intensity (0.0 = no blur, higher = more blur) |
| `blurSides` | `BlurSides`   | required           | Configuration for which sides to blur                  |
| `quality`   | `BlurQuality` | `BlurQuality.high` | Quality setting for performance optimization           |

### BlurSides

Configuration class for controlling blur on different sides.

#### Constructors

- `BlurSides.horizontal({double left, double right})` - Apply blur horizontally
- `BlurSides.vertical({double top, double bottom})` - Apply blur vertically
- `BlurSides._({double top, double bottom, double left, double right})` - Custom configuration

### BlurQuality

Enum for controlling blur quality vs performance:

- `BlurQuality.low` - Faster rendering, lower quality
- `BlurQuality.medium` - Balanced quality and performance
- `BlurQuality.high` - Best quality, slower rendering

## Performance Tips

1. **Use appropriate quality settings**: Lower quality settings for animations, higher for static effects
2. **Limit blur sigma values**: Very high sigma values (>15) can impact performance
3. **Consider widget tree placement**: Apply blur as close to the target widget as possible
4. **Cache blur effects**: For static content, consider using RepaintBoundary

## Examples

The package includes several examples in the `/example` folder:

- Basic variable blur effects
- Tilt-shift photography simulation
- Scroll-responsive blur backgrounds
- Performance optimization techniques

### Visual Examples

| Effect Type | Description |
|------------|-------------|
| **Tilt-Shift Blur** | Professional depth-of-field effects similar to tilt-shift photography |
| **Horizontal Blur** | Apply blur effects horizontally for creative transitions |
| **Vertical Blur** | Vertical blur effects perfect for scroll-based animations |
| **Dynamic Effects** | Real-time blur adjustments based on user interactions |

Run the example app:

```bash
cd example
flutter run
```
