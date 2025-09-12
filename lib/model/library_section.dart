import '../model/book.dart';

class LibrarySection {
  final String libraryName;
  final List<Book> books;

  LibrarySection({
    required this.libraryName,
    required this.books,
  });

  // JSON序列化方法暂时移除，因为Book模型没有相应的方法
  // 如果需要可以后续添加
}