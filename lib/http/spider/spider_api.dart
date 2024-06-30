import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mikuinfo/http/dio_instance.dart';
import 'package:mikuinfo/http/spider/api_string.dart';
import 'package:mikuinfo/model/book.dart';

import '../../model/activity.dart';

class SpiderApi {
  static SpiderApi? _instance;

  SpiderApi._();

  static SpiderApi instance() {
    return _instance ??= SpiderApi._();
  }

  /// 获取首页数据
  Future fetchHomeData({
    Function(List<Activity> values)? activitiesCallback,
    Function(List<Book> values)? booksCallback,
    Function(List<Book> values)? preferbooksCallback,
}) async {
    String htmlStr = await DioInstance.instance().getString(path: ApiString.biliNovelHomeUrl);
    Document doc = parse(htmlStr);

    ///活动数据
    if (activitiesCallback != null) {
      activitiesCallback.call(parseBookActivities(doc));
    }

    ///书籍内容-新书
    if (booksCallback != null){
      booksCallback.call(parseHomeBooks(doc));
    }

    ///书籍内容-推荐
    if (preferbooksCallback != null){
      preferbooksCallback.call(parsePreferBooks(doc));
    }

  }
  List<Activity> parseBookActivities(Document doc){
    List<Element> aEls = doc.querySelectorAll(".slide-container .slide-a");
    List<Activity> activities = [];
    for (Element a in aEls) {
      String? url = ApiString.biliNovelHomeUrl + a.attributes['href']!.trim() ?? "";
      String? cover = ApiString.biliNovelHomeUrl + a.querySelector('.slide-img')!.attributes['src']!.trim() ?? "";
      String? alt = a.querySelector('.slide-img')?.attributes['alt']?.trim() ?? "";

      activities.add(Activity(
          url: url,
          cover: cover,
          alt: alt
      ));
    }
    return activities;
  }

  List<Book> parseHomeBooks(Document doc) {
    List<Element> liEls = doc.querySelectorAll('.book-ol .book-li');
    List<Book> books = [];

    for (Element li in liEls) {
      String? url = ApiString.biliNovelHomeUrl + li.querySelector('.book-layout')!.attributes['href']!.trim() ?? "";
      String bid = ApiString.getId(url, ApiString.bookIdRegExp);
      String? cover = li.querySelector('.book-cover')!.querySelector('img')?.attributes['data-src']!.trim() ?? "";
      String? bookName = li.querySelector('.book-cover')!.querySelector('img')?.attributes['alt']!.trim() ?? "";
      String? bauthor = li.querySelector('.book-meta .book-meta-l .book-author')?.text.trim() ?? "";
      String? author = bauthor == '' ? '' : bauthor.substring(2);
      String? tag = li.querySelector('.tag-small')?.text.trim() ?? "";

      books.add(Book(
        url: url,
        bid: bid,
        cover: cover,
        bookName: bookName,
        author: author,
        tag: tag
      ));
    }
    return books;
  }

  List<Book> parsePreferBooks(Document doc) {
    List<Element> liEls = doc.querySelectorAll('.module-slide-ol .module-slide-li');
    List<Book> preferbooks = [];

    for (Element li in liEls) {
      String? url = ApiString.biliNovelHomeUrl + li.querySelector('.module-slide-a')!.attributes['href']!.trim() ?? "";
      String bid = ApiString.getId(url, ApiString.bookIdRegExp);
      String? cover = li.querySelector('.module-slide-img')!.querySelector('img')?.attributes['data-src']!.trim() ?? "";
      String? bookName = li.querySelector('.module-slide-img')!.querySelector('img')?.attributes['alt']!.trim() ?? "";
      String? bauthor = li.querySelector('.module-slide-author')?.text.trim() ?? "";
      String? author = bauthor == '' ? '' : bauthor.substring(3);

      preferbooks.add(Book(
          url: url,
          bid: bid,
          cover: cover,
          bookName: bookName,
          author: author,
          tag: ''
      ));
    }
    return preferbooks;
  }
}