// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:client_data/package_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'scorecard.dart';
import 'tags.dart';

part 'package.g.dart';

@JsonSerializable()
class Package {
  final PackageData packageData;
  final String publisher;
  final VersionScore versionScore;
  final ScoreCardData scoreCardData;

  Package({
    @required this.packageData,
    @required this.publisher,
    @required this.scoreCardData,
    @required this.versionScore,
  });

  String get name => packageData.name;

  String get description => packageData.latest?.pubspec?.containsKey('description') ?? false
      ? packageData.latest.pubspec['description']
      : null;

  bool get hasPublisher => publisher != null;

  bool get isDartPackage => scoreCardData?.derivedTags?.contains(SdkTag.sdkDart);

  bool get isFlutterPackage => scoreCardData?.derivedTags?.contains(SdkTag.sdkFlutter);

  bool get isNullSafe => scoreCardData?.derivedTags?.contains(PackageVersionTags.isNullSafe);

  factory Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);

  Map<String, dynamic> toJson() => _$PackageToJson(this);
}
