import 'package:flutter/material.dart';
import 'package:hashtagable_v3/detector/detector.dart';

/// Add composing to hashtag decorated text.
///
/// Expected to be used when Japanese or IME letters are typed.
class Composer {
  /// Creates a [Composer] instance to handle composing text and hashtag detections.
  Composer({
    required this.sourceText,
    required this.detections,
    required this.composing,
    required this.selection,
    required this.decoratedStyle,
    required this.onDetectionTyped,
  });

  /// The original full text being composed.
  final String sourceText;

  /// The list of detected hashtag ranges and styles.
  final List<Detection?> detections;

  /// The active composing range (underlined text during IME input).
  final TextRange composing;

  /// The current cursor selection position.
  final int selection;

  /// The text style applied to decorated hashtags.
  final TextStyle decoratedStyle;

  /// Callback invoked when a hashtag or mention is typed.
  final ValueChanged<String>? onDetectionTyped;

  /// Builds a [TextSpan] that handles both hashtag styling and IME composing underline.
  TextSpan getComposedTextSpan() {
    final span = detections.map(
      (item) {
        final spanRange = item!.range;
        final spanStyle = item.style!;
        final underlinedStyle =
            spanStyle.copyWith(decoration: TextDecoration.underline);
        if (spanRange.start <= composing.start &&
            spanRange.end >= composing.end) {
          return TextSpan(
            children: [
              TextSpan(
                  text: TextRange(start: spanRange.start, end: composing.start)
                      .textInside(sourceText),
                  style: spanStyle),
              TextSpan(
                  text: TextRange(start: composing.start, end: composing.end)
                      .textInside(sourceText),
                  style: underlinedStyle),
              TextSpan(
                  text: TextRange(start: composing.end, end: spanRange.end)
                      .textInside(sourceText),
                  style: spanStyle),
            ],
          );
        } else if (spanRange.start >= composing.start &&
            spanRange.end >= composing.end &&
            spanRange.start <= composing.end) {
          return TextSpan(children: [
            TextSpan(
                text: TextRange(start: spanRange.start, end: composing.end)
                    .textInside(sourceText),
                style: underlinedStyle),
            TextSpan(
                text: TextRange(start: composing.end, end: spanRange.end)
                    .textInside(sourceText),
                style: spanStyle)
          ]);
        } else if (spanRange.start <= composing.start &&
            spanRange.end <= composing.end &&
            spanRange.end >= composing.start) {
          return TextSpan(
            children: [
              TextSpan(
                  text: TextRange(start: spanRange.start, end: composing.start)
                      .textInside(sourceText),
                  style: spanStyle),
              TextSpan(
                  text: TextRange(start: composing.start, end: spanRange.end)
                      .textInside(sourceText),
                  style: underlinedStyle),
            ],
          );
        } else {
          return TextSpan(
              text: spanRange.textInside(sourceText), style: spanStyle);
        }
      },
    ).toList();
    return TextSpan(children: span);
  }

  /// Returns the current [Detection] being typed by the user based on cursor position.
  Detection? typingDetection() {
    final res = detections.where(
      (detection) =>
          detection!.style == decoratedStyle &&
          detection.range.start <= selection &&
          detection.range.end >= selection,
    );
    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }

  /// Invokes [onDetectionTyped] with the text currently being typed within a hashtag.
  void callOnDetectionTyped() {
    final typingRange = typingDetection()?.range;
    if (typingRange != null) {
      onDetectionTyped!(typingRange.textInside(sourceText));
    }
  }
}
