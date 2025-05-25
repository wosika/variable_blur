import 'dart:ui';

import 'package:example/gradual_background_blur.dart';
import 'package:flutter/material.dart';
import 'package:variable_blur/variable_blur.dart';

class ImagedBackground extends StatelessWidget {
  const ImagedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: VariableBlur(
        sigma: 8, // Adjust this value to control the blur intensity
        blurSides: BlurSides.vertical(
          top: 0.3,
          bottom: 0.25,
        ), // Adjust the blur sides as needed
        child: Stack(
          children: [
            // Background image
            // Positioned.fill(
            //   child: Image.network(
            //     getTempLink(), // Replace with your image path
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // Foreground content
            Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                    subtitle: Text('Subtitle for item $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
