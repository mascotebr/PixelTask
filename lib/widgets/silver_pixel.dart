import 'package:flutter/material.dart';

import '../model/char.dart';
import '../utils/char_util.dart';

class SilverPixel extends StatefulWidget {
  const SilverPixel({Key? key, required this.char}) : super(key: key);
  final Char char;

  @override
  State<SilverPixel> createState() => _SilverPixelState();
}

class _SilverPixelState extends State<SilverPixel> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      backgroundColor: Color(CharUtil.char.color).withAlpha(25),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Level ${widget.char.level}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${CharUtil.char.exp.round()} / ${CharUtil.maxExp.round()}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: Container(
                      color: Color(widget.char.color),
                      width: MediaQuery.of(context).size.width,
                      height: 4,
                    ),
                  ),
                  Container(
                    color: Color(widget.char.color),
                    width: CharUtil.widthExp(context),
                    height: 4,
                  ),
                ],
              ),
            ),
            const Center(child: FlutterLogo(size: 210)),
            Center(
              child: Text(CharUtil.char.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
