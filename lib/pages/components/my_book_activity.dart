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

  @override
  Widget build(BuildContext context) {
    // 只使用传入的轻小说数据
    final List<LightNovel> novels = lightNovels ?? [];
    final List<LightNovel> visibleNovels =
        novels.where((novel) => novel.isVisible).toList();

    if (visibleNovels.isEmpty && (activities == null || activities!.isEmpty)) {
      return const SizedBox.shrink();
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
                                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0",
                                "Referer": "https://www.wenkuchina.com/",
                                "Cache-Control": "max-age=2592000",
                                "Sec-Ch-Ua": '"Chromium";v="140", "Not=A?Brand";v="24", "Microsoft Edge";v="140"',
                                "Sec-Ch-Ua-Mobile": "?0",
                                "Sec-Ch-Ua-Platform": '"Windows"'
                              },
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 渐变背景
                      Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
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
                      // 文字信息
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(15.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                novel.title ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              4.verticalSpace,
                              Row(
                                children: [
                                  Text(
                                    '作者：${novel.author ?? "未知"}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  Text(
                                    novel.category ?? "",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                              4.verticalSpace,
                              Text(
                                novel.description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 11.sp,
                                  height: 1.2,
                                ),
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
                                  "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0",
                                  "Referer": "https://www.wenkuchina.com/",
                                  "Cache-Control": "max-age=2592000",
                                  "Sec-Ch-Ua": '"Chromium";v="140", "Not=A?Brand";v="24", "Microsoft Edge";v="140"',
                                  "Sec-Ch-Ua-Mobile": "?0",
                                  "Sec-Ch-Ua-Platform": '"Windows"'
                                },
                              ),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    Container(
                      height: 200.h,
                      padding: EdgeInsets.all(15.r),
                      child: Column(
                        children: [
                          Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            activities![index].alt ?? "",
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
