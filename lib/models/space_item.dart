class SpaceItem {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;
  final String endpoint;

  SpaceItem({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    this.endpoint = 'articles',
  });

  factory SpaceItem.fromJson(Map<String, dynamic> json, {String endpoint = 'articles'}) {
    return SpaceItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '-',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      newsSite: json['news_site'] ?? 'Unknown',
      summary: json['summary'] ?? '-',
      publishedAt: json['published_at'] ?? '-',
      endpoint: json['endpoint'] ?? endpoint,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'image_url': imageUrl,
      'news_site': newsSite,
      'summary': summary,
      'published_at': publishedAt,
      'endpoint': endpoint,
    };
  }
}
