import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mikuinfo/pages/bookstore/bookstore_page.dart';
import 'package:mikuinfo/pages/home/homepage.dart';
import 'package:mikuinfo/pages/my_info/my_info_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;

  List rootApp = [
    {
      "icon": LineIcons.bookReader,
      "text": "书架",
    },
    {
      "icon": LineIcons.school,
      "text": "书库",
    },
    {
      "icon": LineIcons.crow,
      "text": "我的",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: _getBottomNavigator(context),
      body: LazyLoadIndexedStack(
        index: _index,
        children: const [
          Homepage(),
          BookstorePage(),
          MyInfoPage()
        ],
      ),
    );
  }

  Widget _getBottomNavigator(BuildContext context) {
    return SalomonBottomBar(
      onTap: (index){
        setState(() {
          _index = index;
        });
      },
      currentIndex: _index,
        items: List.generate(rootApp.length, (index) {
          return SalomonBottomBarItem(
            selectedColor: Theme.of(context).colorScheme.onSurface,
            unselectedColor: Theme.of(context).colorScheme.inversePrimary,
            icon: Icon(rootApp[index]['icon']),
            title: Text(rootApp[index]['text']),
          );
        }));
  }
}


