import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mikuinfo/pages/components/my_book_title.dart';
import 'package:mikuinfo/pages/components/my_search_title.dart';

class Homepage extends StatefulWidget{
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState(){
    return _HomePageState();
  }
}

class _HomePageState extends State<Homepage>{
  List <Map<String, dynamic>> books = [
    {
      "title": "联谊去凑人数的我，把不知为何没人追的前人气偶像国宝级美少女带回家了。",
      "author": "星野星野",
      "tag": "校园 青春 恋爱 欢乐向",
      "cover": "https://img.wenku8.com/image/3/3683/3683s.jpg"
    },
    {
      "title": "即使我喜欢你，你也依然是我的粉丝吗？",
      "author": "恵比须清司",
      "tag": "校园 青春 欢乐向 后宫 青梅竹马 妹妹",
      "cover": "https://img.wenku8.com/image/3/3682/3682s.jpg"
    },
    {
      "title": "葬送的芙莉莲～前奏～",
      "author": "八目迷",
    "tag": "奇幻 冒险 战斗 魔法",
      "cover": "https://img.wenku8.com/image/3/3656/3656s.jpg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: getBodyUI(context, books),
    );
  }
}

Widget getBodyUI(BuildContext context,List <Map<String, dynamic>> books) {
  return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.r),
        child: Column(
          children: [
            10.verticalSpace,
            //头像

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("早上好，MikuFox", style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600
                ),),

                CircleAvatar(
                  backgroundImage: AssetImage('image/avatar.png'),
                )
              ],
            ),
            15.verticalSpace,
            //搜索框

            MySearchTitle(
              bookshelfTap: () {},
            ),

            30.verticalSpace,

            //轻小说推荐
            MyBookTitle(
              name: '近期轻小说',
              books: books,
              width: 120.w,
              height: 160.h,
            ),

            30.verticalSpace,

            MyBookTitle(
              name: '新番原作',
              books: books,
              width: 120.w,
              height: 160.h,
            ),

            30.verticalSpace,

            MyBookTitle(
              name: '最近阅读',
              books: books,
              width: 120.w,
              height: 160.h,
            ),
            //特别为您准备
          ],
        ),
      )
  );
}