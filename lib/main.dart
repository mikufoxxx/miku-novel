import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mikuinfo/http/dio_instance.dart';
import 'package:mikuinfo/pages/root_page.dat.dart';
import 'package:mikuinfo/pages/theme/dark_theme.dart';
import 'package:mikuinfo/pages/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // 初始化DioInstance，设置浏览器头部信息
  DioInstance.instance().initDio();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: MyApp(),
    ),
  );
}

Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  //逻辑短边
  final logicalShortestSize =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  //逻辑长边
  final logicalSLongestSize =
      firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  //缩放比例
  const scaleFactor = 0.95;
  return Size(
      logicalShortestSize * scaleFactor, logicalSLongestSize * scaleFactor);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: Provider.of<ThemeProvider>(context).themeData,
          darkTheme: darkMode,
          home: child,
        );
      },
      child: const RootPage(),
    );
  }
}
