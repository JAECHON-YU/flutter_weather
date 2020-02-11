import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';

import 'common/streams.dart';
import 'language.dart';
import 'model/holder/event_send_holder.dart';
import 'view/page/splash_page.dart';

void main() {
  Observable.just(WidgetsFlutterBinding.ensureInitialized())
      // 显示布局边框
      .map((_) => debugPaintSizeEnabled = false)
      // 设置状态栏字体颜色
      .map((_) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarDividerColor: null,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark)))
      // 强制竖屏
      .asyncMap((_) => SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]))
      .listen((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State createState() => MyAppState();
}

class MyAppState extends State<MyApp> with StreamSubController {
  ThemeData theme = ThemeData();

  @override
  void initState() {
    super.initState();

    EventSendHolder()
        .event
        .where((pair) => pair.a == "themeChange")
        .listen(
            (pair) => setState(() => theme = ThemeData(accentColor: pair.b)))
        .bindLife(this);
  }

  @override
  void dispose() {
    subDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      title: "假装看天气-Flutter版",
      theme: theme,

      // 设置地区信息
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalizationsDelegate.delegate,
      ],

      // 国际化多语言支持
      supportedLocales: [
        const Locale("zh", "CH"),
      ],
    );
  }
}
