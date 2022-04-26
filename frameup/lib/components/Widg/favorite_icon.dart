import 'package:flutter/material.dart';
import 'package:frameup/app/theme.dart';

class FavoriteIconButton extends StatefulWidget {
  const FavoriteIconButton({
    Key? key,
    required this.isfavorite,
    this.size = 22,
    required this.onTap,
  }) : super(key: key);

  final bool isfavorite;

  final double size;

  final Function(bool val) onTap;

  @override
  _FavoriteIconButtonState createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  late bool isfavorite = widget.isfavorite;

  void _handleTap() {
    setState(() {
      isfavorite = !isfavorite;
    });
    widget.onTap(isfavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedCrossFade(
        firstCurve: Curves.easeIn,
        secondCurve: Curves.easeOut,
        firstChild: Icon(
          Icons.star,
          color: Colors.yellow,
          size: widget.size,
        ),
        secondChild: Icon(
          Icons.star_border,
          size: widget.size,
        ),
        crossFadeState:
            isfavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }
}
