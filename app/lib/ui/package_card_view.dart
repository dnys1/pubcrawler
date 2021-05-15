import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:pubcrawler/service/pub_service.dart';
import 'package:pubcrawler/ui/theme.dart';
import 'package:url_launcher/link.dart';

class PackageCardView extends StatelessWidget {
  final Package package;

  const PackageCardView({Key key, @required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 400),
        child: Card(
          shadowColor: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Link(
                        uri: PubService.packageUrl(package.name),
                        target: LinkTarget.blank,
                        builder: (context, FollowLink launch) {
                          return GestureDetector(
                            onTap: launch,
                            child: Text(package.name, style: linkTitleTextStyle),
                          );
                        },
                      ),
                    ),
                    if (package.isNullSafe) ...const [
                      SizedBox(width: 5),
                      NullSafetyBadge(),
                    ]
                  ],
                ),
                SelectableText(
                  package.description,
                  style: const TextStyle(color: textPrimaryColor, fontSize: 14, height: 1.6),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (package.hasPublisher) ...[
                      verifiedPublisherImage,
                      const SizedBox(width: 4),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Link(
                          uri: PubService.publisherUrl(package.publisher),
                          target: LinkTarget.blank,
                          builder: (context, FollowLink launch) {
                            return GestureDetector(
                              onTap: launch,
                              child: Text(package.publisher, style: TextStyle(color: linkColor, fontSize: 12)),
                            );
                          },
                        ),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        if (package.isDartPackage) ...[
                          dartLogo,
                          const SizedBox(width: 4),
                        ],
                        if (package.isFlutterPackage) flutterLogo,
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NullSafetyBadge extends StatelessWidget {
  const NullSafetyBadge({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: const Text('Null safety'),
      labelStyle: TextStyle(
        fontSize: 12,
        color: linkColor,
      ),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: linkColor),
      ),
    );
  }
}
