import 'package:flutter/material.dart';
import 'package:variable_blur/variable_blur.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KernelSizeTest(),
    );
  }
}

class KernelSizeTest extends StatefulWidget {
  const KernelSizeTest({super.key});

  @override
  State<KernelSizeTest> createState() => _KernelSizeTestState();
}

class _KernelSizeTestState extends State<KernelSizeTest> {
  double _kernelSize = 15.0;
  double _sigma = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kernel Size Test'),
      ),
      body: Column(
        children: [
          // Kernel Size Control
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Kernel Size: ${_kernelSize.toStringAsFixed(1)}'),
                Slider(
                  value: _kernelSize,
                  min: 5.0,
                  max: 30.0,
                  onChanged: (value) {
                    setState(() {
                      _kernelSize = value;
                    });
                  },
                ),
                Text('Sigma: ${_sigma.toStringAsFixed(1)}'),
                Slider(
                  value: _sigma,
                  min: 1.0,
                  max: 20.0,
                  onChanged: (value) {
                    setState(() {
                      _sigma = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // Test Image with Blur
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              child: VariableBlur(
                sigma: _sigma,
                kernelSize: _kernelSize,
                blurSides: BlurSides.vertical(top: 0.4, bottom: 0.4),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        Colors.purple,
                        Colors.red,
                        Colors.orange,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Test Blur Effect\nKernel: ${_kernelSize.toInt()}\nSigma: ${_sigma.toInt()}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
