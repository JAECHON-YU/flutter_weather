import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/mzi_data.dart';
import 'package:flutter_weather/model/service/service.dart';
import 'package:html/parser.dart';

class GiftMziImageService extends Service {
  /// 获取每个妹子图集的最大数量
  Future<int> getLength({@required String link}) async {
    final response = await get(link, cancelToken: cancelToken);

    int maxLength = 0;
    final document = parse(response.data);
    final total = document.getElementsByClassName("pagenavi").first;
    final spans = total.querySelectorAll("span");
    spans.map((span) {
      try {
        return int.parse(span.text);
      } on FormatException catch (_) {
        return -1;
      }
    }).forEach((index) {
      if (index > maxLength) {
        maxLength = index;
      }
    });

    return maxLength;
  }

  Future<MziData> getData({@required String link, @required int index}) async {
    final response = await get("$link/$index", cancelToken: cancelToken);

    final document = parse(response.data);
    final total = document.getElementsByClassName("main-image").first;
    final img = total.querySelector("img");
    final url = img.attributes["src"];
    final width = double.parse(img.attributes["width"]).toInt();
    final height = double.parse(img.attributes["height"]).toInt();
    final refer = "$link/";

    return MziData(
        url: url, width: width, height: height, refer: refer, isImages: false);
  }
}
