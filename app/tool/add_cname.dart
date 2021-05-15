import 'dart:io';

import 'package:path/path.dart' as path;

const domain = 'pubcrawler.io';

void main(List<String> args) {
  final tempDir = args[0];
  File(path.join(tempDir, 'CNAME')).writeAsStringSync(domain);
}
