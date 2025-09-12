import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mikuinfo/model/book.dart';
import 'package:mikuinfo/model/library_section.dart';
import 'package:mikuinfo/pages/components/my_book_title.dart';
import 'package:mikuinfo/pages/components/my_library_sections.dart';
import 'package:mikuinfo/pages/components/my_search_title.dart';
import 'package:mikuinfo/pages/home/home_vm.dart';
import 'package:mikuinfo/pages/components/my_book_activity.dart';
import 'package:provider/provider.dart';

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
                        style: TextStyle(
                            fontSize: 22.sp, fontWeight: FontWeight.w600),
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
                  const MyBookActivities(),

                  30.verticalSpace,

                  //本期推荐
                  Selector<HomeViewModel, List<Book>?>(
                      builder: (context, preferbooks, child) {
                        return MyBookTitle(
                          name: '完本推荐',
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
                          name: '新书精选',
                          books: books,
                          width: 120.w,
                          height: 160.h,
                        );
                      },
                      selector: (_, viewModel) => viewModel.books),

                  30.verticalSpace,

                  //热门小说
                  Selector<HomeViewModel, List<LibrarySection>?>(
                      builder: (context, hotBooks, child) {
                        return MyLibrarySections(
                          title: '热门小说',
                          librarySections: hotBooks,
                        );
                      },
                      selector: (_, viewModel) => viewModel.hotBooks),

                  30.verticalSpace,

                  //经典完本
                  Selector<HomeViewModel, List<Book>?>(
                      builder: (context, completedBooks, child) {
                        return MyBookTitle(
                          name: '经典完本',
                          books: completedBooks,
                          width: 120.w,
                          height: 160.h,
                        );
                      },
                      selector: (_, viewModel) => viewModel.completedBooks),

                  30.verticalSpace,

                  //最近更新
                  Selector<HomeViewModel, List<Book>?>(
                      builder: (context, recentUpdates, child) {
                        return MyBookTitle(
                          name: '最近更新',
                          books: recentUpdates,
                          width: 120.w,
                          height: 160.h,
                        );
                      },
                      selector: (_, viewModel) => viewModel.recentUpdates),
                ],
              ),
            ));
      },
    );
  }
}
