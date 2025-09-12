import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mikuinfo/pages/components/my_book_title.dart';
import 'package:mikuinfo/pages/components/my_search_title.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import '../components/my_book_skeleton.dart';
import '../home/home_vm.dart';

class BookstorePage extends StatefulWidget {
  const BookstorePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BookstoreState();
  }
}

class _BookstoreState extends State<BookstorePage> {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getBodyUI(),
    );
  }

  Widget _getBodyUI() {
    return ChangeNotifierProvider.value(
        value: _viewModel,
        builder: (context, child) {
          return SafeArea(
              child: SingleChildScrollView(
            padding: EdgeInsets.all(15.r),
            child: Column(
              children: [
                10.verticalSpace,
                //搜索框

                MySearchTitle(
                  bookshelfTap: () {},
                ),

                30.verticalSpace,

                //本期推荐
                Selector<HomeViewModel, List<Book>?>(
                    builder: (context, List<Book>? preferbooks, child) {
                      if (preferbooks == null) {
                        return const MyBookSkeleton();
                      }
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
                    builder: (context, List<Book>? books, child) {
                      if (books == null) {
                        return const MyBookSkeleton();
                      }
                      return MyBookTitle(
                        name: '新书精选',
                        books: books,
                        width: 120.w,
                        height: 160.h,
                      );
                    },
                    selector: (_, viewModel) => viewModel.books),
                //特别为您准备
              ],
            ),
          ));
        });
  }
}
