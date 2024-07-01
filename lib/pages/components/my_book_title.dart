import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mikuinfo/pages/components/my_book_item.dart';
import 'package:mikuinfo/pages/components/my_book_skeleton.dart';

import '../../model/book.dart';

class MyBookTitle extends StatelessWidget {
  final List<Book>? books;
  final String? name;
  final double? height;
  final double? width;

  const MyBookTitle(
      {super.key, required this.books, this.height, this.width, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name == null ? ' ' : name!,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        15.verticalSpace,

        //书籍信息
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(books?.length ?? 5, (index) {
              if (books == null) {
                return MyBookSkeleton(
                  width: width,
                  height: height,
                );
              }
              return MyBookItem(
                book: books![index],
                width: width,
                height: height,
              );
            }),
          ),
        ),
      ],
    );
  }
}
