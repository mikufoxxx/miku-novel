class Book {
  Book({
    this.bid,
    this.cover,
    this.bookName,
    this.url,
    this.author,
    this.tag,
    this.tags,
    this.isAuthorLoading = false,
    this.isAuthorLoaded = false,
    this.isTagsLoading = false,
    this.isTagsLoaded = false,
  });

  String? bid;
  String? url;
  String? cover;
  String? bookName;
  String? author;
  String? tag;
  List<String>? tags;
  
  // 作者信息加载状态
  bool isAuthorLoading;
  bool isAuthorLoaded;
  
  // 标签信息加载状态
  bool isTagsLoading;
  bool isTagsLoaded;
  
  // 复制方法，用于更新状态
  Book copyWith({
    String? bid,
    String? cover,
    String? bookName,
    String? url,
    String? author,
    String? tag,
    List<String>? tags,
    bool? isAuthorLoading,
    bool? isAuthorLoaded,
    bool? isTagsLoading,
    bool? isTagsLoaded,
  }) {
    return Book(
      bid: bid ?? this.bid,
      cover: cover ?? this.cover,
      bookName: bookName ?? this.bookName,
      url: url ?? this.url,
      author: author ?? this.author,
      tag: tag ?? this.tag,
      tags: tags ?? this.tags,
      isAuthorLoading: isAuthorLoading ?? this.isAuthorLoading,
      isAuthorLoaded: isAuthorLoaded ?? this.isAuthorLoaded,
      isTagsLoading: isTagsLoading ?? this.isTagsLoading,
      isTagsLoaded: isTagsLoaded ?? this.isTagsLoaded,
    );
  }
}