import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class MySearchTitle extends StatelessWidget {
  final VoidCallback? bookshelfTap;
  const MySearchTitle({super.key, this.bookshelfTap});

  @override
  Widget build(BuildContext context) {
    return
      Row(
        children: [
          Expanded(child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15.w),
            height: 40.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text("搜索轻小说_(:з」∠)_", style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 15.sp,
            ),),
          ),),
          Container(
            padding: EdgeInsets.only(left: 10.w),
            child:
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: bookshelfTap,
              icon: Icon(LineIcons.sistrix, size: 35.r,),
            ),
          ),
        ],
      );
  }
}
