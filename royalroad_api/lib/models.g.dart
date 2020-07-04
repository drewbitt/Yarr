part of 'models.dart';

Fiction _$FictionFromJson(Map<String, dynamic> json) {
  return Fiction(
    url: json['url'] as String,
    title: json['title'] as String,
    imageUrl: json['imageUrl'] as String);
}

Map<String, dynamic> _$FictionToJson(Fiction instance) => <String, dynamic>{
  'url': instance.url,
  'title': instance.title,
  'imageUrl': instance.imageUrl};