class LightNovel {
  LightNovel({
    this.id,
    this.title,
    this.author,
    this.category,
    this.description,
    this.coverUrl,
    this.novelUrl,
    this.latestChapter,
    this.latestChapterUrl,
    this.isVisible = true,
    this.opacity = 1.0,
  });

  String? id;
  String? title;
  String? author;
  String? category;
  String? description;
  String? coverUrl;
  String? novelUrl;
  String? latestChapter;
  String? latestChapterUrl;
  bool isVisible;
  double opacity;

  // 从用户提供的HTML数据创建LightNovel实例的工厂方法
  factory LightNovel.fromHtmlData({
    required String id,
    required String title,
    required String author,
    required String category,
    required String description,
    required String coverUrl,
    required String novelUrl,
    required String latestChapter,
    required String latestChapterUrl,
    String displayStyle = 'inline',
    double opacity = 1.0,
  }) {
    return LightNovel(
      id: id,
      title: title,
      author: author,
      category: category,
      description: description,
      coverUrl: coverUrl,
      novelUrl: novelUrl,
      latestChapter: latestChapter,
      latestChapterUrl: latestChapterUrl,
      isVisible: displayStyle != 'none',
      opacity: opacity,
    );
  }
}
