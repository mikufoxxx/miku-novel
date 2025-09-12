import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:mikuinfo/model/activity.dart';
import 'package:mikuinfo/model/light_novel.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBookActivities extends StatelessWidget {
  final List<Activity>? activities;
  final List<LightNovel>? lightNovels;

  const MyBookActivities({super.key, this.activities, this.lightNovels});

  // 启动URL的方法
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // 构建骨架屏加载器
  Widget _buildSkeletonLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                // 骨架屏背景
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.grey[300],
                  ),
                ),
                // 骨架屏文字区域
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                      color: Colors.white.withOpacity(0.95),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 16.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Container(
                              height: 12.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            10.horizontalSpace,
                            Container(
                              height: 12.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 只使用传入的轻小说数据
    final List<LightNovel> novels = lightNovels ?? [];
    final List<LightNovel> visibleNovels =
        novels.where((novel) => novel.isVisible).toList();

    // 如果数据正在加载，显示骨架屏
    if (visibleNovels.isEmpty && (activities == null || activities!.isEmpty)) {
      return _buildSkeletonLoader();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: Swiper(
            itemCount: visibleNovels.isNotEmpty
                ? visibleNovels.length
                : activities!.length,
            autoplay: true,
            autoplayDelay: 4000,
            itemBuilder: (context, index) {
              if (visibleNovels.isNotEmpty) {
                // 显示轻小说数据
                final novel = visibleNovels[index];
                return GestureDetector(
                  onTap: () => _launchUrl(novel.novelUrl ?? ''),
                  child: Stack(
                    children: [
                      Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              novel.coverUrl ?? "",
                              headers: const {
                                "User-Agent":
                                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0",
                                "Referer": "https://www.wenkuchina.com/",
                                "Cache-Control": "max-age=2592000",
                                "Sec-Ch-Ua":
                                    '"Chromium";v="140", "Not=A?Brand";v="24", "Microsoft Edge";v="140"',
                                "Sec-Ch-Ua-Mobile": "?0",
                                "Sec-Ch-Ua-Platform": '"Windows"'
                              },
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // 渐变遮罩
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 文字信息
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                novel.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              6.verticalSpace,
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 14.sp,
                                    color: Colors.white70,
                                  ),
                                  4.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      novel.author ?? "未知作者",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (novel.category != null &&
                                      novel.category!.isNotEmpty) ...[
                                    8.horizontalSpace,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        novel.category!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // 显示原有的活动数据
                return Stack(
                  children: [
                    Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                activities![index].cover ?? "",
                                headers: const {
                                  "User-Agent":
                                      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0",
                                  "Referer": "https://www.wenkuchina.com/",
                                  "Cache-Control": "max-age=2592000",
                                  "Sec-Ch-Ua":
                                      '"Chromium";v="140", "Not=A?Brand";v="24", "Microsoft Edge";v="140"',
                                  "Sec-Ch-Ua-Mobile": "?0",
                                  "Sec-Ch-Ua-Platform": '"Windows"'
                                },
                              ),
                              fit: BoxFit.cover)),
                    ),

                    // 渐变遮罩
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 文字信息
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              activities![index].alt ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            4.verticalSpace,
                            // 标签放在书名下面
                            if (activities![index].tag != null && activities![index].tag!.isNotEmpty) ...[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  activities![index].tag!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              4.verticalSpace,
                            ],
                            // 作者信息
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 14.sp,
                                  color: Colors.white70,
                                ),
                                4.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    activities![index].author ?? "未知作者",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
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
