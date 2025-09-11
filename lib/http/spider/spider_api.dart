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
    String htmlStr = await DioInstance.instance().getString(path: ApiString.wenKuChinaHomeUrl);
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
    List<Element> aEls = doc.querySelectorAll("#index_tpic_big a");
    List<Activity> activities = [];
    for (Element a in aEls) {
      String? url = a.attributes['href']?.trim() ?? "";
      String? cover = a.querySelector('img')?.attributes['src']?.trim() ?? "";
      String? alt = a.querySelector('img')?.attributes['alt']?.trim() ?? "";

      activities.add(Activity(
          url: url,
          cover: cover,
          alt: alt
      ));
    }
    return activities;
  }

  List<Book> parseHomeBooks(Document doc) {
    List<Element> bookEls = doc.querySelectorAll('.mind-book');
    List<Book> books = [];

    for (Element bookEl in bookEls) {
      Element? linkEl = bookEl.querySelector('.imgbox a');
      if (linkEl == null) continue;
      
      String? url = linkEl.attributes['href']?.trim() ?? "";
      String bid = ApiString.getId(url, ApiString.bookIdRegExp);
      Element? imgEl = linkEl.querySelector('img');
      String? cover = imgEl?.attributes['data-original']?.trim() ?? imgEl?.attributes['src']?.trim() ?? "";
      String? bookName = imgEl?.attributes['alt']?.trim() ?? "";
      
      // 处理相对路径的图片URL
      if (cover.isNotEmpty && !cover.startsWith('http')) {
        if (cover.startsWith('/')) {
          cover = 'https://www.wenkuchina.com$cover';
        } else {
          cover = 'https://www.wenkuchina.com/$cover';
        }
      }
      
      // 如果图片为空或包含默认占位图，使用自定义占位图
      if (cover.isEmpty || cover.contains('book-cover-no.svg')) {
        cover = 'https://via.placeholder.com/150x200/cccccc/666666?text=No+Image';
      }
      
      // 从作者链接中提取作者信息
      Element? authorEl = bookEl.querySelector('.author a');
      String author = authorEl?.text.trim() ?? "";
      
      // 从updatenum中提取文库信息作为tag
      Element? tagEl = bookEl.querySelector('.updatenum');
      String tag = tagEl?.text.trim() ?? "";

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
    List<Element> topEls = doc.querySelectorAll('.top-list .top-item');
    List<Book> preferbooks = [];

    for (Element item in topEls) {
      Element? linkEl = item.querySelector('a');
      if (linkEl == null) continue;
      
      String? url = linkEl.attributes['href']?.trim() ?? "";
      String bid = ApiString.getId(url, ApiString.bookIdRegExp);
      
      // 从链接文本中提取书名和作者
      String linkText = linkEl.text.trim();
      String bookName = "";
      String author = "";
      
      if (linkText.contains('作者：')) {
        List<String> parts = linkText.split('作者：');
        if (parts.length >= 2) {
          bookName = parts[0].trim();
          author = parts[1].trim();
        }
      } else {
        bookName = linkText;
      }

      preferbooks.add(Book(
          url: url,
          bid: bid,
          cover: "", // wenkuchina排行榜没有封面图
          bookName: bookName,
          author: author,
          tag: ''
      ));
    }
    return preferbooks;
  }
}