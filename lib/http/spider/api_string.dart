class ApiString {
  static const String wenKuChinaHomeUrl = "https://www.wenkuchina.com";
  static const String bookIdRegExp = r'(?<=/lightnovel/)\d+';

  static String getBookActivityCover(String? style) {
    if (style == null || style.isEmpty) return "";
    return RegExp(style).stringMatch(style) ?? "";
  }

  static String getId(String? content, String reg) {
    if (content == null || content.isEmpty) return "";
    return RegExp(reg).stringMatch(content) ?? "";
  }
}