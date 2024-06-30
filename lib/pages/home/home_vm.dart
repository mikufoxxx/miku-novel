import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mikuinfo/http/spider/spider_api.dart';
import 'package:mikuinfo/model/book.dart';
import '../../model/activity.dart';

class HomeViewModel extends ChangeNotifier{
  List<Activity>? _activities;
  List<Book>? _books;
  List<Book>? _preferbooks;

  List<Activity>? get activities => _activities;
  List<Book>? get books => _books;
  List<Book>? get preferbooks => _preferbooks;

  set activities(List<Activity>? activities){
    _activities = activities;
    notifyListeners();
  }


  set books(List<Book>? books) {
    _books = books;
    notifyListeners();
  }

  set preferbooks(List<Book>? preferbooks) {
    _preferbooks = preferbooks;
    notifyListeners();
  }

  Future getHomePageData() async {
    await SpiderApi.instance().fetchHomeData(
      activitiesCallback: (values) => activities = values,
      booksCallback: (values) => books = values,
      preferbooksCallback: (values) => preferbooks = values,
    );
  }
}