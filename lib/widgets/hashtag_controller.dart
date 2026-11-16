import 'package:flutter/material.dart';
import 'package:hashtagable_v3/composer/composer.dart';
import 'package:hashtagable_v3/detector/detector.dart';

/// A modern [TextEditingController] that decorates hashtags, mentions, and cashtags in real-time.
///
/// Can be used directly in any standard [TextField], [TextFormField], or [CupertinoTextField]
/// without requiring custom widget wrappers.
///
/// Example:
/// ```dart
/// TextFormField(
///   controller: HashTagTextEditingController(
///     decoratedStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
///     decorateAtSign: true,
///     decorateCashtag: true,
///   ),
/// )
/// ```
class HashTagTextEditingController extends TextEditingController {
  /// The [TextStyle] applied to decorated hashtags and mentions.
  final TextStyle? decoratedStyle;

  /// The [TextStyle] applied to normal, untagged text.
  final TextStyle? basicStyle;

  /// Whether to decorate words starting with `@` (mentions).
  final bool decorateAtSign;

  /// Whether to decorate words starting with `$` (cashtags for crypto/stocks).
  final bool decorateCashtag;

  /// Optional list of custom prefix symbols to decorate (e.g. `['#', '@', '$']`).
  final List<String>? customPrefixes;

  /// Callback called whenever the user is actively typing inside a tag.
  final ValueChanged<String>? onTagChanged;

  /// Callback called when the user finishes typing a tag (e.g. whitespace entered).
  final VoidCallback? onTagFinished;

  /// Creates a [HashTagTextEditingController] with customizable tag styling and callbacks.
  HashTagTextEditingController({
    String? text,
    this.decoratedStyle,
    this.basicStyle,
    this.decorateAtSign = false,
    this.decorateCashtag = false,
    this.customPrefixes,
    this.onTagChanged,
    this.onTagFinished,
  }) : super(text: text) {
    if (onTagChanged != null || onTagFinished != null) {
      addListener(_handleTagChange);
    }
  }

  String? _lastTag;

  void _handleTagChange() {
    final detector = Detector(
      textStyle: basicStyle,
      decoratedStyle: decoratedStyle,
      decorateAtSign: decorateAtSign,
      decorateCashtag: decorateCashtag,
      customPrefixes: customPrefixes,
    );
    final detections = detector.getDetections(text);
    final composer = Composer(
      sourceText: text,
      detections: detections,
      composing: value.composing,
      selection: selection.start,
      decoratedStyle: decoratedStyle ?? const TextStyle(color: Colors.blue),
      onDetectionTyped: onTagChanged,
    );

    final currentDetection = composer.typingDetection();
    final currentTag = currentDetection?.range.textInside(text);

    if (currentTag != _lastTag) {
      if (currentTag != null) {
        composer.callOnDetectionTyped();
      } else if (_lastTag != null) {
        onTagFinished?.call();
      }
      _lastTag = currentTag;
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final effectiveBasicStyle =
        basicStyle ?? style ?? DefaultTextStyle.of(context).style;
    final effectiveDecoratedStyle = decoratedStyle ??
        effectiveBasicStyle.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );

    final detector = Detector(
      textStyle: effectiveBasicStyle,
      decoratedStyle: effectiveDecoratedStyle,
      decorateAtSign: decorateAtSign,
      decorateCashtag: decorateCashtag,
      customPrefixes: customPrefixes,
    );

    final detections = detector.getDetections(text);
    if (detections.isEmpty) {
      return super.buildTextSpan(
        context: context,
        style: effectiveBasicStyle,
        withComposing: withComposing,
      );
    }

    final composer = Composer(
      sourceText: text,
      detections: detections,
      composing: withComposing ? value.composing : TextRange.empty,
      selection: selection.start,
      decoratedStyle: effectiveDecoratedStyle,
      onDetectionTyped: onTagChanged,
    );

    return composer.getComposedTextSpan();
  }
}
