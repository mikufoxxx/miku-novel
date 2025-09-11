import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:mikuinfo/model/activity.dart';

class MyBookActivities extends StatelessWidget {
  final List<Activity> activities;
  const MyBookActivities({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150.h,
          width: double.infinity,
          child: Swiper(
            itemCount: activities.length,
            autoplay: true,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    height: 150.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              activities[index].cover ?? "",
                              headers: const {
                                "User-Agent":
                                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0"
                              },
                            ),
                            fit: BoxFit.cover)),
                  ),

                  //背景
                  Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r)),
                  ),

                  //文字
                  Container(
                    height: 150.h,
                    padding: EdgeInsets.all(15.r),
                    child: Column(
                      children: [
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          activities[index].alt ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
            pagination: SwiperPagination(
                alignment: Alignment.bottomRight,
                builder: DotSwiperPaginationBuilder(
                    color: Colors.white.withOpacity(0.4),
                    activeColor: Colors.white,
                    size: 8.0,
                    activeSize: 10.0,
                    space: 2.0)),
          ),
        )
      ],
    );
  }
}
