import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hashtagable_v3/hashtagable.dart';

void main() {
  final decoratedColor = Colors.red;
  final undecoratedColor = Colors.black;
  final detector = Detector(
      textStyle: TextStyle(color: undecoratedColor),
      decoratedStyle: TextStyle(color: decoratedColor));
  test("Decorated text Always counted correctly", () {
    final source =
        "#tag1 あああ #tag2 #高橋3 #たぐ4 #タグ5 eww #tag6 #tag7 #tag8 ararara";
    final result = detector.getDetections(source);
    final decoratedResult =
        result.where((item) => item.style!.color == decoratedColor).toList();
    expect(decoratedResult.length, 8);
  });
  test("When source starts from '#',decorates the source", () {
    final source = "#aAア亜ｂＢ４";
    expect(detector.getDetections(source).length, 1);
    expect(detector.getDetections(source)[0].style!.color, decoratedColor);
  });

  test("When source doesn't include any tags, return empty list", () {
    final source = "aaaaaaaaaaaaaa bbbbbbbbb";
    expect(detector.getDetections(source).isEmpty, true);
  });

  test("Decorated text including Korean letters", () {
    final source = "#안녕 #안녕하세요 #감사 합니다";
    final result = detector.getDetections(source);
    final decoratedResult =
        result.where((item) => item.style!.color == decoratedColor).toList();
    expect(decoratedResult.length, 3);
    expect(detector.getDetections(source)[3].style!.color, undecoratedColor);
  });

  test(
      "When source consists of [untagged, tagged], split it and decorate the tagged one",
      () {
    final source = "abcd #hogehoge";
    expect(detector.getDetections(source).length, 2);
    expect(detector.getDetections(source)[0].style!.color, undecoratedColor);
    expect(detector.getDetections(source)[1].style!.color, decoratedColor);
  });

  test(
      "When source consists of [tagged, untagged], split it and decorate the tagged one",
      () {
    final source = "#hogehoge abcd";
    expect(detector.getDetections(source).length, 2);
    expect(detector.getDetections(source)[1].style!.color, undecoratedColor);
    expect(detector.getDetections(source)[0].style!.color, decoratedColor);
  });

  test(
      "When source consists of [tagged, untagged], split it and decorate the first one",
      () {
    final source = "abcd #hogehoge #hugahuga abcde";
    expect(detector.getDetections(source).length, 5);
    expect(detector.getDetections(source)[0].style!.color, undecoratedColor);
    expect(detector.getDetections(source)[1].style!.color, decoratedColor);
    expect(detector.getDetections(source)[2].style!.color, undecoratedColor);
    expect(detector.getDetections(source)[3].style!.color, decoratedColor);
    expect(detector.getDetections(source)[4].style!.color, undecoratedColor);
  });

  test("When tag includes emoji, split and undecorate the text after emoji",
      () {
    final source = "#abc😄def";
    expect(detector.getDetections(source)[0].range,
        const TextRange(start: 0, end: 4));
    expect(detector.getDetections(source)[0].style!.color, decoratedColor);
  });

  test(
      "When tag doesn't include emoji but text does, it needs to decorate properly",
      () {
    final source = "#abc def😆";
    final res = detector.getDetections(source);
    expect(res.length, 2);
    expect(res[0].style!.color, decoratedColor);
    expect(res[1].style!.color, undecoratedColor);
  });

  test("When tag includes symbol, split and undecorate the text after emoji",
      () {
    final source = "#abc!def";
    expect(detector.getDetections(source)[0].range,
        const TextRange(start: 0, end: 4));
    expect(detector.getDetections(source)[1].style!.color, undecoratedColor);
  });

  test(" 'ー' must be contained in tagged text", () {
    final source = "#あーい";
    expect(detector.getDetections(source)[0].range,
        const TextRange(start: 0, end: 4));
  });

  test("'_' must be contained in tagged text", () {
    final source = "#abc_def";
    expect(detector.getDetections(source).length, 1);
  });

  test("Decoration mustn't started with \n", () {
    final source = "\n#hashtag";
    expect(detector.getDetections(source).length, 2);
    expect(detector.getDetections(source)[1].style!.color, decoratedColor);
  });

  test("Stop decoration if it contains \n", () {
    final source = "#hash\ntag";
    expect(detector.getDetections(source).length, 2);
    expect(detector.getDetections(source)[0].style!.color, decoratedColor);
  });

  test("check if functions are working correctly", () {
    final hasHashtagsTrue = hasHashTags("#hashtag hashtag");
    final hasHashtagFalse = hasHashTags("hashtag hashtag");
    final hashTagList = extractHashTags("#hello world #Thank You #So Much");
    expect(hasHashtagsTrue, true);
    expect(hasHashtagFalse, false);
    expect(hashTagList[0], "#hello");
    expect(hashTagList[1], "#Thank");
    expect(hashTagList[2], "#So");
    expect(hashTagList.length, 3);
  });

  test("detect hashtag before the full width space", () {
    final source = "The space right before the hashtag is　#fullWidth";
    expect(hasHashTags(source), true);
  });

  test("detect and extract mentions (@)", () {
    final source = "Hello @emmanuel and @openneom welcome!";
    expect(hasMentions(source), true);
    final mentions = extractMentions(source);
    expect(mentions.length, 2);
    expect(mentions[0], "@emmanuel");
    expect(mentions[1], "@openneom");
  });

  test(r"detect and extract cashtags ($)", () {
    final source = r"Buy $BTC and $ETH today!";
    expect(hasCashtags(source), true);
    final cashtags = extractCashtags(source);
    expect(cashtags.length, 2);
    expect(cashtags[0], r"$BTC");
    expect(cashtags[1], r"$ETH");
  });

  test("custom prefixes detection", () {
    final customDetector = Detector(
      textStyle: const TextStyle(color: Colors.black),
      decoratedStyle: const TextStyle(color: Colors.red),
      customPrefixes: ['#', '@', r'$'],
    );
    final source = r"Check #flutter with @user and $SOL";
    final detections = customDetector.getDetections(source);
    final tagged = detections.where((d) => d.style!.color == Colors.red).toList();
    expect(tagged.length, 3);
  });

  testWidgets("HashTagTextEditingController builds styled spans in TextField",
      (tester) async {
    final controller = HashTagTextEditingController(
      text: "Hello #flutter and @openneom",
      decoratedStyle: const TextStyle(color: Colors.blue),
      basicStyle: const TextStyle(color: Colors.black),
      decorateAtSign: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(controller: controller),
        ),
      ),
    );

    final span = controller.buildTextSpan(
      context: tester.element(find.byType(TextField)),
      withComposing: false,
    );

    expect(span.children, isNotNull);
    expect(span.children!.length, greaterThan(1));
  });

  test("Lote 76: createTagRegExp escapes ']', '-', '^', '\\' and getHashTagTextSpan avoids leaked recognizers", () {
    final trickyDetector = Detector(
      textStyle: const TextStyle(color: Colors.black),
      decoratedStyle: const TextStyle(color: Colors.red),
      customPrefixes: [']', '-', '^', r'\', '#'],
    );
    final detections = trickyDetector.getDetections(r']uno -dos ^tres \cuatro #cinco texto');
    final tagged = detections.where((d) => d.style?.color == Colors.red).toList();
    expect(tagged.length, 5);

    // Large emoji + hashtag payload runs in linear time without splitting surrogate pairs
    final heavyEmoji = '${'🔥🎉🚀' * 600} #itzli ${'🎶✨' * 600}';
    expect(extractHashTags(heavyEmoji), ['#itzli']);

    // When onTap is null, zero TapGestureRecognizers are allocated; when onTap is set, ONLY tagged spans get recognizers
    final noTapSpan = getHashTagTextSpan(
      decoratedStyle: const TextStyle(color: Colors.red),
      basicStyle: const TextStyle(color: Colors.black),
      source: 'hola #mundo libre',
      onTap: null,
    );
    expect(
      noTapSpan.children!.whereType<TextSpan>().every((s) => s.recognizer == null),
      isTrue,
    );

    final withTapSpan = getHashTagTextSpan(
      decoratedStyle: const TextStyle(color: Colors.red),
      basicStyle: const TextStyle(color: Colors.black),
      source: 'hola #mundo libre',
      onTap: (_) {},
    );
    final childSpans = withTapSpan.children!.whereType<TextSpan>().toList();
    expect(childSpans[0].recognizer, isNull); // 'hola '
    expect(childSpans[1].recognizer, isNotNull); // '#mundo'
    expect(childSpans[2].recognizer, isNull); // ' libre'
    for (final s in childSpans) {
      s.recognizer?.dispose();
    }
  });
}

