import 'package:flutter/cupertino.dart';

class BrandSizeBox extends StatelessWidget {
  const BrandSizeBox({
    super.key,
    this.height,
    this.width,
    this.child,
  });
  final double? height;
  final double? width;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 10,
      width: width ?? 10,
      child: child,
    );
  }
}
