import 'package:flutter/material.dart';
import 'package:hashtagable_v3/hashtagable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hashtagable_v3 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  late final HashTagTextEditingController _controller;
  String _activeTag = '';

  @override
  void initState() {
    super.initState();
    _controller = HashTagTextEditingController(
      text: "Building apps with #Flutter and @openneom! Investing in \$BTC 🚀",
      decoratedStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
      basicStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      decorateAtSign: true,
      decorateCashtag: true,
      onTagChanged: (tag) {
        setState(() {
          _activeTag = tag;
        });
      },
      onTagFinished: () {
        setState(() {
          _activeTag = '';
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hashtagable_v3 Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              '1. Read-Only Display (HashTagText)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: HashTagText(
                text:
                    "Welcome to #hashtagable_v3!\nConnect with @openneom or check \$ETH & \$BTC.",
                basicStyle: const TextStyle(fontSize: 16, color: Colors.black87),
                decoratedStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                decorateAtSign: true,
                decorateCashtag: true,
                onTap: (tag) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped tag: $tag')),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '2. Modern Controller in Standard TextFormField',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Type with #hashtag, @mention, or \$cashtag...',
              ),
            ),
            if (_activeTag.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Actively typing: $_activeTag',
                style: const TextStyle(
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
