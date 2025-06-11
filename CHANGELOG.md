## 0.0.7

### Added
- Added `kernelSize` parameter to `VariableBlur` for fine-grained control over blur smoothness and performance.
- Both horizontal and vertical shaders now accept a `kernelSize` uniform, allowing kernel size to be set from Flutter.
- Example and documentation updated to demonstrate and explain the new `kernelSize` parameter.
- Added performance tips and best practices for kernel size and sigma selection.

### Changed
- Cleaned up unused uniforms in shaders (removed `edgeIntensity` from horizontal pass).
- Improved documentation for all parameters, including new usage examples and API table.

### Fixed
- Previously, using sigma values greater than 15 was not recommended and could result in poor blur or performance issues.
- Now, with the new `kernelSize` parameter, you can safely use higher sigma values and adjust the blur quality and performance as needed.
- Added `kernelSize` to `VariableBlur` for advanced control over blur smoothness.

## 0.0.6

- **VISUAL**: Added comprehensive screenshot gallery to README.md for better pub.dev presentation
- **IMPROVED**: Enhanced README.md with visual examples showcasing different blur effects
- **OPTIMIZED**: Refined package description to meet pub.dev character limits (60-180 chars)
- **ENHANCED**: Added organized image gallery displaying tilt-shift, horizontal, vertical, and dynamic blur effects
- **PRESENTATION**: Improved package discoverability with prominent visual examples in documentation
- **POLISH**: Better structured README layout for professional pub.dev package listing

## 0.0.5
- **DOCUMENTATION**: Comprehensive API documentation added to meet pub.dev standards (20%+ coverage achieved)
- **NEW**: Added detailed dartdoc comments for all public API elements
- **IMPROVED**: Enhanced library-level documentation with features overview and usage examples
- **ADDED**: Important compatibility notes - blur effects only work on images or colored containers
- **ENHANCED**: Detailed class and method documentation with performance considerations
- **QUALITY**: Added comprehensive examples and best practices in documentation
- **REFERENCES**: Clear references to example app for implementation guidance

## 0.0.4

- **BREAKING FIX**: Fixed coordinate system compatibility between iOS and Android platforms
- **NEW**: Added platform-aware rendering to prevent upside-down blur effects on Android
- **IMPROVED**: Enhanced cross-platform shader compatibility with automatic coordinate system detection
- **TECHNICAL**: Added platform detection logic to handle different coordinate origins (iOS: bottom-left, Android: top-left)
- **PERFORMANCE**: Optimized shader branching for platform-specific coordinate transformations

## 0.0.3

- Documentation updates and package maintenance

## 0.0.2

- Internal improvements and bug fixes

## 0.0.1

- Initial release with variable blur effects
- Tilt-shift blur implementation with GPU shaders
- Customizable blur sides (top, bottom, left, right)
- Performance-optimized blur rendering
- Quality control settings (low, medium, high)
- Cross-platform support for Flutter applications
