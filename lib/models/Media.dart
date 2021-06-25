class Media {
  String thumbnail;
  String medium;
  String cover;
  Media(String url) {
    if (url != null) {
      List<String> urls = url.split(" ");
      for (String u in urls) {
        if (u.contains("small"))
          thumbnail = u;
        else if (u.contains("medium"))
          medium = u;
        else {
          cover = u;
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'medium': medium,
      'cover': cover,
    };
  }

  @override
  String toString() {
    return "$thumbnail $medium $cover";
  }
}
