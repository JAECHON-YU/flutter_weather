import 'package:flutter/material.dart';
import 'package:flutter_weather/common/colors.dart';

/// 加载网络图片
class NetImage extends StatelessWidget {
  /// 图片url地址
  final String url;

  /// 图片宽高
  final double height;
  final double width;

  final BoxFit fit;

  /// 是否为圆形图片
  final bool isCircle;
  final Map<String, String> headers;
  final Widget placeholder;

  NetImage(
      {Key key,
      @required this.url,
      this.height,
      this.width,
      this.isCircle = false,
      this.headers,
      this.fit = BoxFit.cover,
      this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || url == "null") {
      return Container(
        height: height,
        width: width,
        color: AppColor.holder,
      );
    }

    final img = Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      headers: headers,
    );

    return isCircle ? ClipOval(child: img) : img;
  }
}
