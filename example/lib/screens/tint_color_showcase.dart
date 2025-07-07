import 'package:flutter/material.dart';
import 'package:variable_blur/variable_blur.dart';

/// A showcase screen demonstrating the tint color functionality of VariableBlur.
///
/// This screen shows various examples of how to use tint colors with blur effects
/// to create artistic and visually appealing results using real images.
class TintColorShowcase extends StatefulWidget {
  const TintColorShowcase({super.key});

  @override
  State<TintColorShowcase> createState() => _TintColorShowcaseState();
}

class _TintColorShowcaseState extends State<TintColorShowcase> {
  Color _selectedColor = Colors.blue;
  double _opacity = 0.3;
  double _sigma = 10.0;
  double _topBlur = 0.3;
  double _bottomBlur = 0.3;

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Tint Color Showcase'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildDemoCard(
                    'Vertical Tilt-Shift with Tint',
                    VariableBlur(
                      sigma: _sigma,
                      isYFlipNeed: true,
                      blurSides: BlurSides.vertical(
                        top: _topBlur,
                        bottom: _bottomBlur,
                      ),
                      tintColor: _selectedColor.withOpacity(_opacity),
                      edgeIntensity: 0.2,
                      child: Image.network(
                        _sampleImages[0],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.error, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _buildDemoCard(
                    'Horizontal Blur with Tint',
                    VariableBlur(
                      sigma: _sigma,
                      isYFlipNeed: true,
                      blurSides: BlurSides.horizontal(left: 0.3, right: 0.3),
                      tintColor: _selectedColor.withOpacity(_opacity),
                      edgeIntensity: 0.2,
                      child: Image.network(
                        _sampleImages[1],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.error, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _buildDemoCard(
                    'All Sides Blur with Tint',
                    VariableBlur(
                      sigma: _sigma,
                      isYFlipNeed: true,
                      blurSides: BlurSides.vertical(top: 0.2, bottom: 0.2),
                      tintColor: _selectedColor.withOpacity(_opacity),
                      edgeIntensity: 0.3,
                      child: Image.network(
                        _sampleImages[2],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.error, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildDemoCard(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildColorPicker(),
              const SizedBox(height: 20),
              _buildSlider('Opacity', _opacity, 0.0, 1.0, (value) {
                setState(() => _opacity = value);
              }),
              _buildSlider('Blur Intensity', _sigma, 0.0, 20.0, (value) {
                setState(() => _sigma = value);
              }),
              _buildSlider('Top Blur', _topBlur, 0.0, 1.0, (value) {
                setState(() => _topBlur = value);
              }),
              _buildSlider('Bottom Blur', _bottomBlur, 0.0, 1.0, (value) {
                setState(() => _bottomBlur = value);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tint Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _selectedColor == color
                                ? Colors.black
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: _selectedColor,
        ),
      ],
    );
  }
}
