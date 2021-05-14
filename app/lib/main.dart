import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:pubcrawler/service/pub_service.dart';
import 'package:pubcrawler/ui/package_card_view.dart';
import 'package:pubcrawler/ui/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pubCrawler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: fontFamily,
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _pubService = PubService();
  Package _loadedPackage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNewPackage();
  }

  Future<void> _loadNewPackage() async {
    setState(() => _isLoading = true);
    try {
      _loadedPackage = await _pubService.getRandomPackage();
    } on Exception {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PubCrawlerLogo(),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _isLoading || _loadedPackage == null
                        ? const CircularProgressIndicator()
                        : PackageCardView(package: _loadedPackage),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  child: const Icon(Icons.refresh),
                  onPressed: _isLoading ? null : _loadNewPackage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PubCrawlerLogo extends StatelessWidget {
  const PubCrawlerLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'pubCrawler',
      style: Theme.of(context).textTheme.headline3.apply(color: Colors.white),
    );
  }
}
