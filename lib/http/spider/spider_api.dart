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

  /// 从书籍详情页获取标签列表
  Future<List<String>> getBookTagsList(String bookUrl) async {
    try {
      String htmlStr = await DioInstance.instance().getString(path: bookUrl);
      Document doc = parse(htmlStr);

      // 获取book-label中的标签信息
      Element? labelEl = doc.querySelector('.book-label');
      if (labelEl == null) return [];

      List<String> tags = [];

      // 获取分类标签（如：校园、青春、恋爱等）- 这些是最重要的标签
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

      // 如果没有分类标签，则添加其他标签作为备选
      if (tags.isEmpty) {
        // 获取状态（连载/完结）
        Element? stateEl = labelEl.querySelector('.state');
        if (stateEl != null) {
          tags.add(stateEl.text.trim());
        }

        // 获取类型标签（如：日本轻小说）
        List<Element> rgLabels = labelEl.querySelectorAll('.label.rg');
        for (Element rgLabel in rgLabels) {
          tags.add(rgLabel.text.trim());
        }
      }

      // 返回前3个标签
      return tags.take(3).toList();
    } catch (e) {
      return [];
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
    String htmlStr = await DioInstance.instance()
        .getString(path: ApiString.wenKuChinaHomeUrl);
    Document doc = parse(htmlStr);

    ///活动数据
    if (activitiesCallback != null) {
      List<Activity> activities = await parseBookActivities(doc);
      activitiesCallback.call(activities);
    }

    ///书籍内容-新书
    if (booksCallback != null) {
      List<Book> homeBooks = await parseHomeBooks(doc);
      booksCallback.call(homeBooks);
    }

    ///书籍内容-推荐
    if (preferbooksCallback != null) {
      preferbooksCallback.call(parsePreferBooks(doc));
    }

    ///热门小说
    if (hotBooksCallback != null) {
      List<LibrarySection> hotBooks = await parseHotBooks(doc);
      hotBooksCallback.call(hotBooks);
    }

    ///经典完本
    if (completedBooksCallback != null) {
      completedBooksCallback.call(parseCompletedBooks(doc));
    }

    ///最近更新
    if (recentUpdatesCallback != null) {
      recentUpdatesCallback.call(parseRecentUpdates(doc));
    }
  }

  Future<List<Activity>> parseBookActivities(Document doc) async {
    List<Activity> activities = [];

    // 获取轮播图图片信息
    List<Element> imgElements = doc.querySelectorAll('#index_tpic_big a');
    // 获取轮播图文本信息
    List<Element> infoElements = doc.querySelectorAll('#index_tpic_binfo .index_tpic_info');
    
    // 确保图片和信息数量匹配
    int minLength = imgElements.length < infoElements.length ? imgElements.length : infoElements.length;
    
    for (int i = 0; i < minLength; i++) {
      Element imgElement = imgElements[i];
      Element infoElement = infoElements[i];
      
      // 从图片元素获取URL和封面
      String url = imgElement.attributes['href']?.trim() ?? '';
      Element? imgEl = imgElement.querySelector('img');
      String cover = imgEl?.attributes['src']?.trim() ?? '';
      String alt = imgEl?.attributes['alt']?.trim() ?? '';
      
      // 处理相对路径的图片URL
      if (cover.isNotEmpty && !cover.startsWith('http')) {
        if (cover.startsWith('/')) {
          cover = 'https://www.wenkuchina.com\$cover';
        } else {
          cover = 'https://www.wenkuchina.com/\$cover';
        }
      }
      
      // 从信息元素获取作者和标签
      String author = '未知作者';
      Element? authorElement = infoElement.querySelector('.author a');
      if (authorElement != null) {
        author = authorElement.text.trim();
      }
      
      // 从详情页获取标签信息
      String tag = '轻小说';
      if (url.isNotEmpty) {
        try {
           String detailUrl = url.startsWith('http') ? url : 'https://www.wenkuchina.com$url';
           String detailHtml = await DioInstance.instance().getString(path: detailUrl);
           Document detailDoc = parse(detailHtml);
          
          // 从详情页的.book-label span中获取标签
           Element? labelSpan = detailDoc.querySelector('.book-label span');
           if (labelSpan != null) {
             List<Element> tagElements = labelSpan.querySelectorAll('a');
             if (tagElements.isNotEmpty) {
               // 获取所有标签并用逗号分隔
               List<String> tags = tagElements.map((e) => e.text.trim()).toList();
               tag = tags.join('、');
             }
           }
        } catch (e) {
          print('获取详情页标签失败: $e');
          // 如果获取详情页失败，尝试从当前页面获取类型信息
          Element? cateElement = infoElement.querySelector('.cate a');
          if (cateElement != null) {
            tag = cateElement.text.trim();
          }
        }
      }
      
      if (url.isNotEmpty) {
        activities.add(Activity(
          url: url.startsWith('http') ? url : 'https://www.wenkuchina.com\$url',
          cover: cover,
          alt: alt,
          author: author,
          tag: tag,
        ));
      }
    }
    
    return activities;
  }

  Future<List<Book>> parseHomeBooks(Document doc) async {
    List<Element> bookEls = doc.querySelectorAll('.mind-book');
    List<Book> books = [];

    for (Element bookEl in bookEls) {
      Element? linkEl = bookEl.querySelector('.imgbox a');
      if (linkEl == null) continue;

      String? url = linkEl.attributes['href']?.trim() ?? "";
      String bid = ApiString.getId(url, ApiString.bookIdRegExp);
      Element? imgEl = linkEl.querySelector('img');
      String? cover = imgEl?.attributes['data-original']?.trim() ??
          imgEl?.attributes['src']?.trim() ??
          "";
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

      // 使用基础标签信息，不同步等待详情页加载
      List<String> realTags = [];
      
      // 尝试从当前元素中提取基础标签
      Element? labelEl = bookEl.querySelector('.book-label');
      if (labelEl != null) {
        Element? spanEl = labelEl.querySelector('span');
        if (spanEl != null) {
          List<Element> tagLinks = spanEl.querySelectorAll('a');
          for (Element tagLink in tagLinks) {
            String tagText = tagLink.text.trim();
            if (tagText.isNotEmpty) {
              realTags.add(tagText);
            }
          }
        }
      }
      
      // 如果没有找到标签，使用tag作为备选
      if (realTags.isEmpty && tag.isNotEmpty) {
        realTags = [tag];
      }
      
      // 调试输出
      print('HomeBook: $bookName, tag: $tag, tags: ${realTags.take(3).join(' ')}');
      
      books.add(Book(
          url: url,
          bid: bid,
          cover: cover,
          bookName: bookName,
          author: author,
          tag: tag,
          tags: realTags.take(3).toList()));
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
          tag: '',
          tags: [])); // 推荐书籍暂时没有标签
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
            cover =
                "https://www.wenkuchina.com/files/article/image/$firstDir/$bid/${bid}s.jpg";
          }
        }
        // 使用基础标签信息，不同步等待详情页加载
        String tag = libraryName.isNotEmpty ? libraryName : libraryTag;
        List<String> realTags = [tag]; // 使用基础标签，后续异步加载详细标签
        
        // 调试输出
        print('Book: $bookName, tag: $tag, tags: ${realTags.join(' ')}');

        books.add(Book(
            url: url,
            bid: bid,
            cover: cover,
            bookName: bookName,
            author: "", // 作者信息将通过懒加载获取
            tag: tag,
            tags: realTags, // 使用从详情页获取的真正标签
            isAuthorLoading: false,
            isAuthorLoaded: false));
      }

      if (books.isNotEmpty) {
        librarySections
            .add(LibrarySection(libraryName: libraryName, books: books));
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
          tag: "完本",
          tags: ["完本"])); // 完本标签
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
        author = spans[2].text.trim(); // 作者
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
          tag: tag,
          tags: library.isNotEmpty ? [library] : [])); // 使用文库作为标签
    }
    return recentUpdates;
  }
}
