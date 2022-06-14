import 'package:flutter/material.dart';

class SilverPixel extends StatefulWidget {
  const SilverPixel({Key? key}) : super(key: key);

  @override
  State<SilverPixel> createState() => _SilverPixelState();
}

class _SilverPixelState extends State<SilverPixel> {
  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: FlutterLogo(),
      ),
    );
  }
}
