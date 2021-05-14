// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'scorecard.g.dart';

abstract class PackageFlags {
  static const String isDiscontinued = 'discontinued';
  static const String isLatestStable = 'latest-stable';
  static const String isLegacy = 'legacy';
  static const String isObsolete = 'obsolete';
  static const String usesFlutter = 'uses-flutter';
}

abstract class FlagMixin {
  List<String> get flags;

  bool get isDiscontinued => flags != null && flags.contains(PackageFlags.isDiscontinued);

  bool get isLegacy => flags != null && flags.contains(PackageFlags.isLegacy);

  bool get isObsolete => flags != null && flags.contains(PackageFlags.isObsolete);

  bool get isSkipped => isDiscontinued || isLegacy || isObsolete;

  bool get usesFlutter => flags != null && flags.contains(PackageFlags.usesFlutter);
}

@JsonSerializable()
class ScoreCardData extends Object with FlagMixin {
  final String packageName;
  final String packageVersion;
  final String runtimeVersion;
  final DateTime updated;
  final DateTime packageCreated;
  final DateTime packageVersionCreated;

  /// Granted score from pana and dartdoc analysis.
  final int grantedPubPoints;

  /// Max score from pana and dartdoc analysis.
  /// `null` if report is not ready yet.
  /// `0` if analysis was not running
  final int maxPubPoints;

  /// Score for package popularity (0.0 - 1.0).
  final double popularityScore;

  /// List of tags computed by `pana` or other analyzer.
  final List<String> derivedTags;

  /// The flags for the package, version or analysis.
  @override
  final List<String> flags;

  /// The report types that are already done for the ScoreCard.
  final List<String> reportTypes;

  ScoreCardData({
    this.packageName,
    this.packageVersion,
    this.runtimeVersion,
    this.updated,
    this.packageCreated,
    this.packageVersionCreated,
    this.grantedPubPoints,
    this.maxPubPoints,
    this.popularityScore,
    this.derivedTags,
    this.flags,
    this.reportTypes,
  });

  factory ScoreCardData.fromJson(Map<String, dynamic> json) => _$ScoreCardDataFromJson(json);

  bool get isNew => DateTime.now().difference(packageCreated).inDays <= 30;

  Map<String, dynamic> toJson() => _$ScoreCardDataToJson(this);

  /// Whether the data has all the required report types.
  bool hasReports(List<String> requiredTypes) {
    if (requiredTypes == null || requiredTypes.isEmpty) return true;
    if (reportTypes == null || reportTypes.isEmpty) return false;
    return requiredTypes.every(reportTypes.contains);
  }
}

abstract class ReportData {
  String get reportType;
  String get reportStatus;
  Map<String, dynamic> toJson();
}
