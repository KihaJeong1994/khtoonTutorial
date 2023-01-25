class WebtoonModel {
  final String id, title, thumb;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        thumb = json['thumb'],
        title = json['title'];
}
