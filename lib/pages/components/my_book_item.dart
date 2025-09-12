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
                    color: Colors.grey[200]),
                child: book.cover == null || book.cover!.isEmpty
                    ? _buildStaticCover()
                    : CachedNetworkImage(
                        imageUrl: book.cover!,
                        httpHeaders: {
                          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0",
                          "Referer": "https://www.wenkuchina.com/",
                          "Cache-Control": "max-age=2592000",
                          "Sec-Ch-Ua": '"Chromium";v="140", "Not=A?Brand";v="24", "Microsoft Edge";v="140"',
                          "Sec-Ch-Ua-Mobile": "?0",
                          "Sec-Ch-Ua-Platform": '"Windows"'
                        },
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.grey[300],
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => _buildStaticCover(),
                      ),
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

  Widget _buildStaticCover() {
    // 使用默认占位符，不再依赖静态数据
    return _buildErrorPlaceholder();
  }
  
  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey[400]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 30.sp,
            color: Colors.orange[600],
          ),
          SizedBox(height: 5.h),
          Text(
            '图片加载失败',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
