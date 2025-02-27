import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MyBookSkeleton extends StatelessWidget {
  final String? name;
  final double? height;
  final double? width;

  const MyBookSkeleton({super.key, this.height, this.width, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: Shimmer.fromColors(
          baseColor: Theme
              .of(context)
              .colorScheme
              .inverseSurface,
          highlightColor: Theme
              .of(context)
              .colorScheme
              .onInverseSurface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    //封面
                    Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Theme
                            .of(context)
                            .colorScheme
                            .inverseSurface,
                      ),
                    ),
                  ]),
                    10.verticalSpace,

                    //标题
                    Container(
                      padding: EdgeInsets.only(top: 10.h),
                      height: 20.h,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Theme
                            .of(context)
                            .colorScheme
                            .inverseSurface,
                      ),
                    ),

                    5.verticalSpace,
                    //副标题
                    Container(
                      padding: EdgeInsets.only(top: 5.h),
                      height: 18.h,
                      width: width == null ? null : width! - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Theme
                            .of(context)
                            .colorScheme
                            .inverseSurface,
                      ),
                    )
                  ],
              ),
        ));
  }
}
