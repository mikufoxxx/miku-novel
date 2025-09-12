class Book {
  Book({
    this.bid,
    this.cover,
    this.bookName,
    this.url,
    this.author,
    this.tag,
    this.isAuthorLoading = false,
    this.isAuthorLoaded = false,
  });

  String? bid;
  String? url;
  String? cover;
  String? bookName;
  String? author;
  String? tag;
  
  // 作者信息加载状态
  bool isAuthorLoading;
  bool isAuthorLoaded;
  
  // 复制方法，用于更新状态
  Book copyWith({
    String? bid,
    String? cover,
    String? bookName,
    String? url,
    String? author,
    String? tag,
    bool? isAuthorLoading,
    bool? isAuthorLoaded,
  }) {
    return Book(
      bid: bid ?? this.bid,
      cover: cover ?? this.cover,
      bookName: bookName ?? this.bookName,
      url: url ?? this.url,
      author: author ?? this.author,
      tag: tag ?? this.tag,
      isAuthorLoading: isAuthorLoading ?? this.isAuthorLoading,
      isAuthorLoaded: isAuthorLoaded ?? this.isAuthorLoaded,
    );
  }
}