# Variable Blur Examples

This Flutter application showcases comprehensive examples of the Variable Blur package, demonstrating various blur effects and techniques for creating professional depth-of-field and variable blur effects.

## Examples Included

### 1. **Tilt-Shift Photography** 📸

Interactive tilt-shift blur effects that simulate professional depth-of-field photography techniques.

- Real-time blur adjustment controls
- Multiple preset configurations
- Image selection and quality settings
- Professional photography simulation

### 2. **Scroll Blur Header** 📜

Dynamic blur effects that respond to scroll position, perfect for creating engaging headers and navigation elements.

- Scroll-based blur intensity
- Smooth transitions
- Content overlay effects
- Instructional user interface

### 3. **Interactive Blur Demo** 🎛️

Comprehensive real-time blur controls with visualization overlay and preset configurations.

- Individual side blur controls (top, bottom, left, right)
- Blur intensity and tint adjustments
- Quality settings and presets
- Visual blur zone indicators

### 4. **Wallpaper Gallery** 🖼️

Beautiful blur effects integrated into a gallery interface with scroll-based header blur.

- Grid-based image gallery
- Modal detail views with blur
- Scroll-responsive header effects
- Professional gallery UI

### 5. **Blur Transitions** 🎬

Smooth animated blur transitions demonstrating various animation techniques.

- Fade blur effects
- Slide blur transitions
- Rotate blur patterns
- Pulse blur animations

### 6. **Performance Comparison** ⚡

Performance testing and comparison tool for analyzing blur effect impact on application performance.

- Real-time FPS monitoring
- Animated element stress testing
- Blur performance analysis
- Configurable test parameters

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd variable_blur/example
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the application:**

   ```bash
   # For development
   flutter run

   # For web
   flutter run -d chrome

   # For specific device
   flutter run -d <device-id>
   ```

## Project Structure

```
lib/
├── main.dart                           # Application entry point
└── examples/
    ├── example_showcase.dart           # Main navigation hub
    ├── tilt_shift_photography.dart     # Tilt-shift effects demo
    ├── scroll_blur_header.dart         # Scroll-based blur demo
    ├── interactive_blur_demo.dart      # Interactive controls demo
    ├── wallpaper_gallery.dart          # Gallery with blur effects
    ├── blur_transitions.dart           # Animated transitions demo
    └── performance_comparison.dart     # Performance testing tool
```

## Key Features Demonstrated

- **Variable Blur Effects**: Different blur intensities and patterns
- **Interactive Controls**: Real-time parameter adjustment
- **Animation Integration**: Smooth blur transitions and effects
- **Performance Optimization**: Efficient blur rendering techniques
- **UI/UX Best Practices**: Professional interface design
- **Responsive Design**: Adaptive layouts for different screen sizes

## Usage Tips

1. **Start with Example Showcase**: Navigate from the main hub to explore individual examples
2. **Experiment with Controls**: Each example includes interactive controls to modify blur parameters
3. **Performance Testing**: Use the Performance Comparison tool to understand blur impact
4. **Code Reference**: Check individual example files for implementation details

## Development Notes

- All examples use external images from Unsplash for demonstration
- Each example is self-contained and can be used as a reference
- Performance examples include FPS monitoring for optimization guidance
- Interactive controls demonstrate real-time parameter adjustment

## Troubleshooting

### Common Issues

- **Slow Performance**: Reduce blur strength or number of elements in performance demo
- **Network Images**: Ensure internet connection for external image loading
- **Platform Compatibility**: Some effects may perform differently across platforms

### Performance Tips

- Use appropriate blur strength values (5-15 typical range)
- Consider device capabilities when implementing blur effects
- Test on target devices for optimal performance

## Learn More

- [Variable Blur Package Documentation](../README.md)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)

## Contributing

Feel free to contribute additional examples or improvements to existing demonstrations. Each example should be well-documented and include interactive controls where appropriate.
