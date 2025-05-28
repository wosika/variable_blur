## 0.0.3

- **BREAKING FIX**: Fixed coordinate system compatibility between iOS and Android platforms
- **NEW**: Added platform-aware rendering to prevent upside-down blur effects on Android
- **IMPROVED**: Enhanced cross-platform shader compatibility with automatic coordinate system detection
- **TECHNICAL**: Added platform detection logic to handle different coordinate origins (iOS: bottom-left, Android: top-left)
- **PERFORMANCE**: Optimized shader branching for platform-specific coordinate transformations

## 0.0.2

- **BREAKING FIX**: Fixed coordinate system compatibility between iOS and Android platforms
- **NEW**: Added platform-aware rendering to prevent upside-down blur effects on Android
- **IMPROVED**: Enhanced cross-platform shader compatibility with automatic coordinate system detection
- **TECHNICAL**: Added platform detection logic to handle different coordinate origins (iOS: bottom-left, Android: top-left)
- **PERFORMANCE**: Optimized shader branching for platform-specific coordinate transformations

## 0.0.1

- Initial release with variable blur effects
- Tilt-shift blur implementation with GPU shaders
- Customizable blur sides (top, bottom, left, right)
- Performance-optimized blur rendering
- Quality control settings (low, medium, high)
- Cross-platform support for Flutter applications
