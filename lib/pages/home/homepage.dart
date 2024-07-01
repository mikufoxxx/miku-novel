import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mikuinfo/model/activity.dart';
import 'package:mikuinfo/model/book.dart';
import 'package:mikuinfo/pages/components/my_book_title.dart';
import 'package:mikuinfo/pages/components/my_search_title.dart';
import 'package:mikuinfo/pages/home/home_vm.dart';
import 'package:mikuinfo/pages/components/my_book_activity.dart';
import 'package:provider/provider.dart';

import '../components/my_book_activities_skeleton.dart';
import '../components/my_book_skeleton.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<Homepage> {

  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel.getHomePageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getBodyUI(),
    );
  }

  Widget _getBodyUI() {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      builder: (context, child) {
        return SafeArea(
          top: true,
            child: SingleChildScrollView(
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              10.verticalSpace,
              //头像

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "早上好，MikuFox",
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
                  ),
                  const CircleAvatar(
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

              //轮播图
              Selector<HomeViewModel, List<Activity>?>(
                  builder: (context, List<Activity>? activities, child) {
                    if (activities == null) {
                      return const MyBookActivitiesSkeleton();
                    }
                    return MyBookActivities(activities: activities);
                  },
                  selector: (_, viewModel) => viewModel.activities),

              30.verticalSpace,


              //本期推荐
              Selector<HomeViewModel, List<Book>?>(
                  builder: (context, preferbooks, child) {
                    return MyBookTitle(
                      name: '本期强推',
                      books: preferbooks,
                      width: 120.w,
                      height: 160.h,
                    );
                  },
                  selector: (_, viewModel) => viewModel.preferbooks),

              30.verticalSpace,

              //新书抢先
              Selector<HomeViewModel, List<Book>?>(
                  builder: (context, books, child) {
                    return MyBookTitle(
                      name: '新书抢先',
                      books: books,
                      width: 120.w,
                      height: 160.h,
                    );
                  },
                  selector: (_, viewModel) => viewModel.books),

            ],
          ),
        ));
      },
    );
  }
}
