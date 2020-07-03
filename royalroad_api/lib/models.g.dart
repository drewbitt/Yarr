part of 'models.dart';

Fiction _$FictionFromJson(Map<String, dynamic> json) {
  return Fiction(
    json['url'] as String,
    json['title'] as String,
    json['imageUrl'] as String);
}

Map<String, dynamic> _$FictionToJson(Fiction instance) => <String, dynamic>{
  'url': instance.url,
  'title': instance.title,
  'imageUrl': instance.imageUrl};