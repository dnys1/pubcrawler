// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) {
  return Package(
    packageData: json['packageData'] == null
        ? null
        : PackageData.fromJson(json['packageData'] as Map<String, dynamic>),
    publisher: json['publisher'] as String,
    scoreCardData: json['scoreCardData'] == null
        ? null
        : ScoreCardData.fromJson(json['scoreCardData'] as Map<String, dynamic>),
    versionScore: json['versionScore'] == null
        ? null
        : VersionScore.fromJson(json['versionScore'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'packageData': instance.packageData,
      'publisher': instance.publisher,
      'versionScore': instance.versionScore,
      'scoreCardData': instance.scoreCardData,
    };
