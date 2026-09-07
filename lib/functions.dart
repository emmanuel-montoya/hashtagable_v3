import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';

import 'detector/detector.dart';

/// Check if the text has hashTags
bool hasHashTags(String value) {
  const decoratedTextColor = Colors.blue;
  final detector = Detector(
      textStyle: const TextStyle(),
      decoratedStyle: const TextStyle(color: decoratedTextColor));
  final result = detector.getDetections(value);
  final detections = result
      .where((detection) => detection.style!.color == decoratedTextColor)
      .toList();
  return detections.isNotEmpty;
}

/// Check if the text has mentions (@)
bool hasMentions(String value) {
  const decoratedTextColor = Colors.purple;
  final detector = Detector(
      textStyle: const TextStyle(),
      decoratedStyle: const TextStyle(color: decoratedTextColor),
      decorateAtSign: true);
  final result = detector.getDetections(value);
  final detections = result.where((d) {
    if (d.style!.color != decoratedTextColor) return false;
    final txt = d.range.textInside(value).trim();
    return txt.startsWith('@');
  }).toList();
  return detections.isNotEmpty;
}

/// Check if the text has cashtags ($)
bool hasCashtags(String value) {
  const decoratedTextColor = Colors.green;
  final detector = Detector(
      textStyle: const TextStyle(),
      decoratedStyle: const TextStyle(color: decoratedTextColor),
      decorateCashtag: true);
  final result = detector.getDetections(value);
  final detections = result.where((d) {
    if (d.style!.color != decoratedTextColor) return false;
    final txt = d.range.textInside(value).trim();
    return txt.startsWith(r'$');
  }).toList();
  return detections.isNotEmpty;
}

/// Extract hashTags from the text
List<String> extractHashTags(String value) {
  const decoratedTextColor = Colors.blue;
  final detector = Detector(
      textStyle: const TextStyle(),
      decoratedStyle: const TextStyle(color: decoratedTextColor));
  final detections = detector.getDetections(value);
  final taggedDetections = detections
      .where((detection) => detection.style!.color == decoratedTextColor)
      .toList();
  final result = taggedDetections.map((decoration) {
    final text = decoration.range.textInside(value);
    return text.trim();
  }).toList();
  return result;
}

/// Extract mentions (@username) from the text
List<String> extractMentions(String value) {
  const decoratedTextColor = Colors.purple;
  final detector = Detector(
      textStyle: const TextStyle(),
      decoratedStyle: const TextStyle(color: decoratedTextColor),
      decorateAtSign: true);
  final detections = detector.getDetections(value);
  final taggedDetections = detections
      .where((detection) => detection.style!.color == decoratedTextColor)
      .toList();
  final result = taggedDetections
      .map((decoration) => decoration.range.textInside(value).trim())
      .where((text) => text.startsWith('@'))
      .toList();
  return result;
}

/// Extract cashtags ($SYMBOL) from the text
List<String> extractCashtags(String value) {
  const decoratedTextColor = Colors.green;
  final detector = Detector(
      textStyle: const TextStyle(),
      decoratedStyle: const TextStyle(color: decoratedTextColor),
      decorateCashtag: true);
  final detections = detector.getDetections(value);
  final taggedDetections = detections
      .where((detection) => detection.style!.color == decoratedTextColor)
      .toList();
  final result = taggedDetections
      .map((decoration) => decoration.range.textInside(value).trim())
      .where((text) => text.startsWith(r'$'))
      .toList();
  return result;
}

/// Returns textSpan with decorated tagged text
///
/// Used in [HashTagText]
TextSpan getHashTagTextSpan({
  required TextStyle decoratedStyle,
  required TextStyle basicStyle,
  required String source,
  Function(String)? onTap,
  bool decorateAtSign = false,
  bool decorateCashtag = false,
  List<String>? customPrefixes,
}) {
  final decorations = Detector(
          decoratedStyle: decoratedStyle,
          textStyle: basicStyle,
          decorateAtSign: decorateAtSign,
          decorateCashtag: decorateCashtag,
          customPrefixes: customPrefixes)
      .getDetections(source);
  if (decorations.isEmpty) {
    return TextSpan(text: source, style: basicStyle);
  } else {
    decorations.sort();
    final span = decorations
        .asMap()
        .map(
          (index, item) {
            final recognizer = TapGestureRecognizer()
              ..onTap = () {
                final decoration = decorations[index];
                if (decoration.style == decoratedStyle) {
                  onTap!(decoration.range.textInside(source).trim());
                }
              };
            return MapEntry(
              index,
              TextSpan(
                style: item.style,
                text: item.range.textInside(source),
                recognizer: (onTap == null) ? null : recognizer,
              ),
            );
          },
        )
        .values
        .toList();

    return TextSpan(children: span);
  }
}
