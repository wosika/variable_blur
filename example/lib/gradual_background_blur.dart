import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:variable_blur/variable_blur.dart';
import 'dart:math' as math;

class GradualBackgroundBlur extends StatefulWidget {
  const GradualBackgroundBlur({super.key});

  @override
  _GradualBackgroundBlurState createState() => _GradualBackgroundBlurState();
}

class _GradualBackgroundBlurState extends State<GradualBackgroundBlur> {
  bool isClipped = false;
  final ScrollController _scrollController = ScrollController();

  double blurSigma = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    Future.delayed(Duration(seconds: 1)).then((value) {
      _scrollController.animateTo(
        300,
        duration: Duration(seconds: 1),
        curve: Curves.linear,
      );
    });
  }

  void _onScroll() {
    const maxBlur = 8.0;
    const scrollThreshold = 200.0;

    if (_scrollController.offset < scrollThreshold) {
      // Calculate blurSigma based on scroll position
      setState(() {
        blurSigma = maxBlur * (_scrollController.offset / scrollThreshold);
        if (blurSigma == maxBlur) {}
      });
      print("blurSigma $blurSigma");
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove listener
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return SizedBox(height: 100);
                    }
                    if (index == 1) {
                      return Container(
                        child: Image.network(getTempLink(), fit: BoxFit.cover),
                      );
                    }
                    return ListTile(title: Text(index.toString()));
                  },
                ),
              ),
            ],
          ),
          if (isClipped)
            Align(
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigma,
                      sigmaY: blurSigma,
                    ),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Switch.adaptive(
                value: isClipped,
                onChanged: (value) {
                  setState(() {
                    isClipped = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );

    if (isClipped) {
      return child;
    } else {
      return VariableBlur(
        blurTint: Colors.red,
        sigma: 0, // Blur strength
        blurSides: BlurSides.vertical(
          top: 0, // Blur top 20%
          bottom: 0.3, // Blur bottom 10%
        ),
        child: child,
      );
    }
  }
}

String getTempLink({int height = 812, int width = 375}) {
  return 'https://picsum.photos/$width/$height';
}
