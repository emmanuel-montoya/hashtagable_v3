
# hashtagable_v3

[![pub package](https://img.shields.io/pub/v/hashtagable_v3.svg)](https://pub.dev/packages/hashtagable_v3)
[![pub points](https://img.shields.io/pub/points/hashtagable_v3)](https://pub.dev/packages/hashtagable_v3/score)
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

Widgets, functions, and controllers to implement hashtag, mention, and cashtag decorated text in Flutter.

Detects words starting with `#` (hashtags), `@` (mentions), `$` (cashtags/crypto/stocks), or any custom prefixes of your choice like Twitter / X, Bluesky, Instagram, and Reddit.

![Demo](https://user-images.githubusercontent.com/43510799/93001716-1d981280-f56c-11ea-8700-f181f7850455.gif)

---

## What's New in v3.1.0 🚀

- **`HashTagTextEditingController`**: A lightweight `TextEditingController` that brings instant tag decoration and typing callbacks to standard Flutter `TextField`, `TextFormField`, and `CupertinoTextField` without widget wrappers!
- **Cashtag Support (`$`)**: Tag financial tickers and cryptocurrencies (e.g. `$BTC`, `$TSLA`, `$ETH`) using `decorateCashtag: true`.
- **Custom Prefixes**: Highlight any custom symbols using `customPrefixes: ['#', '@', '$', '!']`.
- **Modern Flutter & TextScaler**: Full support for Flutter 3.22+, `TextScaler`, and `WidgetStateProperty`.
- **Extraction Utilities**: `hasMentions()`, `hasCashtags()`, `extractMentions()`, and `extractCashtags()`.

---

## Installation

Add `hashtagable_v3` to your `pubspec.yaml`:

```yaml
dependencies:
  hashtagable_v3: ^3.1.0
```

---

## Usage

### 1. Modern Controller (Recommended)

Use `HashTagTextEditingController` directly in any standard `TextField` or `TextFormField`:

```dart
final controller = HashTagTextEditingController(
  text: "Hello #flutter and @openneom with \$BTC!",
  decoratedStyle: const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
  basicStyle: const TextStyle(
    color: Colors.black,
  ),
  decorateAtSign: true,
  decorateCashtag: true,
  onTagChanged: (tag) {
    print("Currently typing tag: $tag");
  },
  onTagFinished: () {
    print("Tag completed");
  },
);

@override
Widget build(BuildContext context) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      hintText: "What's happening? Use #tags, @mentions, or \$cashtags",
    ),
  );
}
```

### 2. ReadOnly Display Text

If you want to display decorated text with clickable tags, use `HashTagText`:

```dart
HashTagText(
  text: "#Welcome to #hashtagable with @openneom and \$BTC!",
  decoratedStyle: const TextStyle(fontSize: 18, color: Colors.blue),
  basicStyle: const TextStyle(fontSize: 18, color: Colors.black),
  decorateAtSign: true,
  decorateCashtag: true,
  onTap: (tag) {
    print("User tapped tag: $tag");
  },
)
```

### 3. As HashTagTextField (Legacy Component)

You can also continue using the standalone `HashTagTextField`:

```dart
HashTagTextField(
  decoratedStyle: const TextStyle(fontSize: 14, color: Colors.blue),
  basicStyle: const TextStyle(fontSize: 14, color: Colors.black),
  decorateAtSign: true,
  decorateCashtag: true,
  onDetectionTyped: (tag) {
    print("Typing: $tag");
  },
)
```

---

## Custom Symbols & Prefixes

To decorate arbitrary symbols (for instance `#`, `@`, `$`, `!`, or `§`), pass `customPrefixes`:

```dart
HashTagText(
  text: "Highlight !important notice and ?query along with #topic",
  customPrefixes: const ['!', '?', '#'],
  decoratedStyle: const TextStyle(color: Colors.deepOrange),
  basicStyle: const TextStyle(color: Colors.black),
  onTap: (symbolTag) => print(symbolTag),
)
```

---

## Useful Functions

### Detection & Extraction

```dart
// Hashtags (#)
hasHashTags("Hello #World"); // true
extractHashTags("#Hello #Flutter Dart #ThankYou"); // ["#Hello", "#Flutter", "#ThankYou"]

// Mentions (@)
hasMentions("Ping @emmanuel and @openneom"); // true
extractMentions("Ping @emmanuel and @openneom"); // ["@emmanuel", "@openneom"]

// Cashtags ($)
hasCashtags(r"Buy $BTC and $ETH"); // true
extractCashtags(r"Buy $BTC and $ETH"); // ["$BTC", "$ETH"]
```

### Rich Text Span Generation

Generate custom `TextSpan` trees anywhere in your UI:

```dart
final TextSpan span = getHashTagTextSpan(
  decoratedStyle: const TextStyle(color: Colors.blue),
  basicStyle: const TextStyle(color: Colors.black),
  source: "Check out #hashtagable by @openneom!",
  decorateAtSign: true,
  onTap: (tag) => print(tag),
);
```

---

## Supported Languages & Rules

- Supports English, Japanese, Korean, Spanish, Arabic, Thai, Norwegian, German, and more.
- Respects punctuation and emojis: stops decoration when hitting emojis or special punctuation.
- Requires whitespace (or start-of-line) before tag prefixes to avoid false positives in email addresses or URLs.

---

## Contributors & Attribution

- Maintained by [Emmanuel Montoya](https://github.com/emmanuel-montoya) / [OpenNeom](https://openneom.dev).
- Original creator and contributors: [Santa Takahashi](https://github.com/santa112358), [Matheus Perez](https://github.com/matheusperez), [Marcel Schneider](https://github.com/SchnMar), [Ho Kim](https://github.com/kerryeon), [Burak](https://github.com/buraktabn).

Issues & feature requests welcome at [github.com/emmanuel-montoya/hashtagable_v3](https://github.com/emmanuel-montoya/hashtagable_v3/issues).

