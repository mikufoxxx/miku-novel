import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mikuinfo/http/spider/spider_api.dart';
import 'package:mikuinfo/model/book.dart';
import 'package:mikuinfo/model/library_section.dart';
import '../../model/activity.dart';

class HomeViewModel extends ChangeNotifier{
  List<Activity>? _activities;
  List<Book>? _books;
  List<Book>? _preferbooks;
  List<LibrarySection>? _hotBooks;
  List<Book>? _completedBooks;
  List<Book>? _recentUpdates;

  List<Activity>? get activities => _activities;
  List<Book>? get books => _books;
  List<Book>? get preferbooks => _preferbooks;
  List<LibrarySection>? get hotBooks => _hotBooks;
  List<Book>? get completedBooks => _completedBooks;
  List<Book>? get recentUpdates => _recentUpdates;

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

  set hotBooks(List<LibrarySection>? hotBooks) {
    _hotBooks = hotBooks;
    notifyListeners();
  }

  set completedBooks(List<Book>? completedBooks) {
    _completedBooks = completedBooks;
    notifyListeners();
  }

  set recentUpdates(List<Book>? recentUpdates) {
    _recentUpdates = recentUpdates;
    notifyListeners();
  }

  Future getHomePageData() async {
    await SpiderApi.instance().fetchHomeData(
      activitiesCallback: (values) => activities = values,
      booksCallback: (values) => books = values,
      preferbooksCallback: (values) => preferbooks = values,
      hotBooksCallback: (values) => hotBooks = values,
      completedBooksCallback: (values) => completedBooks = values,
      recentUpdatesCallback: (values) => recentUpdates = values,
    );
  }
}