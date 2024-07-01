import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/book.dart';

class MyBookItem extends StatelessWidget {
  final Book book;
  final double? height;
  final double? width;
  const MyBookItem({super.key, required this.book, this.height, this.width});

  @override
  Widget build(BuildContext context) {
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
                          book.cover ?? '',
                          headers: {
                            "User-Agent":
                                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0"
                          }),
                      fit: BoxFit.cover,
                    )),
              ),

              book.tag == ''
                  ? const SizedBox()
                  : Positioned(
                      bottom: height == null ? 20 : height! / 20,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        width: 120.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            )),
                        child: Center(
                          child: Text(
                            maxLines: 1,
                            book.tag ?? '',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ))
            ],
          ),

          //标题
          Container(
            padding: EdgeInsets.only(top: 10.h),
            width: 120.w,
            child: Text(
              maxLines: 1,
              book.bookName ?? '',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          //副标题
          Container(
            padding: EdgeInsets.only(top: 5.h),
            width: 120.w,
            child: Text(
              maxLines: 1,
              book.author ?? '',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          )
        ],
      ),
    );
  }
}
