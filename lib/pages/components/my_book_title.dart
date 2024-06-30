import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/book.dart';

class MyBookTitle extends StatelessWidget {
  final List<Book> books;
  final String? name;
  final double? height;
  final double? width;
  const MyBookTitle({super.key,required this.books, this.height, this.width, this.name});

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name == null ? ' ' : name!, style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),),

          15.verticalSpace,

          //书籍信息
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(books.length, (index){
                return Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          //封面
                          Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      books[index].cover ?? '',
                                      headers: {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0"}
                                  ),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),


                          books[index].tag == '' ? const SizedBox() : Positioned(
                              bottom: height == null ? 20 : height! / 20,
                              child:
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                width: 120.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12.r),
                                      bottomRight: Radius.circular(12.r),
                                    )
                                ),
                                child: Center(
                                  child: Text( maxLines: 1, books[index].tag ?? '', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                                ),
                              )
                          )
                        ],
                      ),

                      //标题
                      Container(
                        padding: EdgeInsets.only(top: 10.h),
                        width: 120.w,
                        child: Text(
                          maxLines: 1,
                          books[index].bookName ?? '', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                      ),
                      //副标题
                      Container(
                        padding: EdgeInsets.only(top: 5.h),
                        width: 120.w,
                        child: Text(
                          maxLines: 1,
                          books[index].author ?? '', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.inversePrimary),),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),],
      );
  }
}
