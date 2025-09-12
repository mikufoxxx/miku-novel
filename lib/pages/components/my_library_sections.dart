import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mikuinfo/model/library_section.dart';
import 'package:mikuinfo/pages/components/my_book_item.dart';
import 'package:mikuinfo/pages/components/my_book_skeleton.dart';

class MyLibrarySections extends StatelessWidget {
  final List<LibrarySection>? librarySections;
  final String? title;

  const MyLibrarySections({
    super.key,
    required this.librarySections,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主标题
        Text(
          title ?? '热门小说',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        20.verticalSpace,
        
        // 文库分组列表
        if (librarySections == null)
          // 加载状态
          Column(
            children: List.generate(3, (index) => 
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    15.verticalSpace,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(3, (bookIndex) => 
                          MyBookSkeleton(
                            width: 120.w,
                            height: 160.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          // 实际内容
          Column(
            children: librarySections!.map((section) => 
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 文库名称
                    Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          section.libraryName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    
                    // 该文库下的书籍列表
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: section.books.map((book) => 
                          MyBookItem(
                            book: book,
                            width: 120.w,
                            height: 160.h,
                          ),
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ),
      ],
    );
  }
}