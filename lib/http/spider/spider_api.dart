import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:mikuinfo/http/dio_instance.dart';
import 'package:mikuinfo/http/spider/api_string.dart';
import 'package:mikuinfo/model/book.dart';
import 'package:mikuinfo/model/library_section.dart';

import '../../model/activity.dart';

class SpiderApi {
  static SpiderApi? _instance;

  SpiderApi._();

  static SpiderApi instance() {
    return _instance ??= SpiderApi._();
  }

  /// 从书籍详情页获取作者信息
  Future<String> getBookAuthor(String bookUrl) async {
    try {
      String htmlStr = await DioInstance.instance().getString(path: bookUrl);
      Document doc = parse(htmlStr);
      
      // 获取作者信息，位于.au-name a中
      Element? authorEl = doc.querySelector('.au-name a');
      if (authorEl != null) {
        return authorEl.text.trim();
      }
      
      return "";
    } catch (e) {
      return "";
    }
  }

  /// 从书籍详情页获取标签信息
  Future<String> getBookTags(String bookUrl) async {
    try {
      String htmlStr = await DioInstance.instance().getString(path: bookUrl);
      Document doc = parse(htmlStr);
      
      // 获取book-label中的标签信息
      Element? labelEl = doc.querySelector('.book-label');
      if (labelEl == null) return "";
      
      List<String> tags = [];
      
      // 获取状态（连载/完结）
      Element? stateEl = labelEl.querySelector('.state');
      if (stateEl != null) {
        tags.add(stateEl.text.trim());
      }
      
      // 获取文库信息
      Element? libraryEl = labelEl.querySelector('.label');
      if (libraryEl != null) {
        tags.add(libraryEl.text.trim());
      }
      
      // 获取类型标签（如：日本轻小说）
      List<Element> rgLabels = labelEl.querySelectorAll('.label.rg');
      for (Element rgLabel in rgLabels) {
        tags.add(rgLabel.text.trim());
      }
      
      // 获取分类标签（如：校园、青春、恋爱等）
      Element? spanEl = labelEl.querySelector('span');
      if (spanEl != null) {
        List<Element> tagLinks = spanEl.querySelectorAll('a');
        for (Element tagLink in tagLinks) {
          String tagText = tagLink.text.trim();
          if (tagText.isNotEmpty) {
            tags.add(tagText);
          }
        }
      }
      
      // 返回前3个最重要的标签，用空格分隔
      return tags.take(3).join(' ');
    } catch (e) {
      return "";
    }
  }

  /// 获取首页数据
  Future fetchHomeData({
    Function(List<Activity> values)? activitiesCallback,
    Function(List<Book> values)? booksCallback,
    Function(List<Book> values)? preferbooksCallback,
    Function(List<LibrarySection> values)? hotBooksCallback,
    Function(List<Book> values)? completedBooksCallback,
    Function(List<Book> values)? recentUpdatesCallback,
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

    ///热门小说
    if (hotBooksCallback != null) {
      List<LibrarySection> hotBooks = await parseHotBooks(doc);
      hotBooksCallback.call(hotBooks);
    }

    ///经典完本
    if (completedBooksCallback != null){
      completedBooksCallback.call(parseCompletedBooks(doc));
    }

    ///最近更新
    if (recentUpdatesCallback != null){
      recentUpdatesCallback.call(parseRecentUpdates(doc));
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
      
      // 如果图片为空或包含默认占位图，保持为空
      if (cover.isEmpty || cover.contains('book-cover-no.svg')) {
        cover = "";
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

  /// 解析热门小说（按文库分级）
  Future<List<LibrarySection>> parseHotBooks(Document doc) async {
    List<Element> cateEls = doc.querySelectorAll('.cate-blank .cate-cell');
    List<LibrarySection> librarySections = [];

    for (Element cateEl in cateEls) {
      // 获取文库名称
      Element? titleEl = cateEl.querySelector('.title');
      String libraryName = titleEl?.text.trim() ?? "";
      
      // 获取该文库下的书籍列表
      List<Element> bookEls = cateEl.querySelectorAll('.lists ul li');
      List<Book> books = [];
      
      for (Element item in bookEls) {
        Element? linkEl = item.querySelector('a');
        if (linkEl == null) continue;
        
        String? url = linkEl.attributes['href']?.trim() ?? "";
        String bid = ApiString.getId(url, ApiString.bookIdRegExp);
        
        // 获取书名
        String bookName = linkEl.text.trim();
        
        // 获取文库标签
        Element? spanEl = item.querySelector('span');
        String libraryTag = spanEl?.text.trim() ?? "";
        
        // 根据书籍ID拼接封面URL（参考静态数据格式）
        String cover = "";
        if (bid.isNotEmpty) {
          // 根据示例HTML分析，封面URL格式规律：
          // ID 1-999: 目录为 0
          // ID 1000-1999: 目录为 1  
          // ID 2000-2999: 目录为 2
          // ID 3000-3999: 目录为 3
          // 即：目录 = ID的千位数字
          int bidNum = int.tryParse(bid) ?? 0;
          if (bidNum > 0) {
            String firstDir = (bidNum ~/ 1000).toString();
            cover = "https://www.wenkuchina.com/files/article/image/$firstDir/$bid/${bid}s.jpg";
          }
        }
        // 使用文库名称作为tag
        String tag = libraryName.isNotEmpty ? libraryName : libraryTag;

        books.add(Book(
            url: url,
            bid: bid,
            cover: cover,
            bookName: bookName,
            author: "", // 作者信息将通过懒加载获取
            tag: tag,
            isAuthorLoading: false,
            isAuthorLoaded: false
        ));
      }
      
      if (books.isNotEmpty) {
        librarySections.add(LibrarySection(
          libraryName: libraryName,
          books: books
        ));
      }
    }
    return librarySections;
  }

  /// 解析经典完本（完本推荐）
  List<Book> parseCompletedBooks(Document doc) {
    List<Element> completedEls = doc.querySelectorAll('.livelybox a');
    List<Book> completedBooks = [];

    for (Element linkEl in completedEls) {
      String? url = linkEl.attributes['href']?.trim() ?? "";
      String bid = ApiString.getId(url, ApiString.bookIdRegExp);
      
      // 获取书名
      String bookName = linkEl.text.trim();
      
      // 获取作者 - 从父级元素查找
      Element? parentEl = linkEl.parent;
      String author = "";
      if (parentEl != null) {
        List<Element> textNodes = parentEl.querySelectorAll('*');
        for (Element node in textNodes) {
          String text = node.text.trim();
          if (text.isNotEmpty && text != bookName && !text.contains('完本')) {
            author = text;
            break;
          }
        }
      }

      completedBooks.add(Book(
          url: url,
          bid: bid,
          cover: "", // 完本推荐没有封面图
          bookName: bookName,
          author: author,
          tag: "完本"
      ));
    }
    return completedBooks;
  }

  /// 解析最近更新
  List<Book> parseRecentUpdates(Document doc) {
    List<Element> updateEls = doc.querySelectorAll('.main_con li');
    List<Book> recentUpdates = [];

    for (Element item in updateEls) {
      Element? linkEl = item.querySelector('a');
      if (linkEl == null) continue;
      
      String? url = linkEl.attributes['href']?.trim() ?? "";
      String bid = ApiString.getId(url, ApiString.bookIdRegExp);
      
      // 获取书名
      String bookName = linkEl.text.trim();
      
      // 获取作者和其他信息
      List<Element> spans = item.querySelectorAll('span');
      String author = "";
      String library = "";
      String updateTime = "";
      
      if (spans.length >= 3) {
        library = spans[0].text.trim(); // 文库
        author = spans[2].text.trim();  // 作者
        if (spans.length >= 5) {
          updateTime = spans[4].text.trim(); // 更新时间
        }
      }
      
      String tag = library.isNotEmpty && updateTime.isNotEmpty 
          ? "$library · $updateTime" 
          : (library.isNotEmpty ? library : updateTime);

      recentUpdates.add(Book(
          url: url,
          bid: bid,
          cover: "", // 最近更新列表没有封面图
          bookName: bookName,
          author: author,
          tag: tag
      ));
    }
    return recentUpdates;
  }

}