import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hashtagable_v3/functions.dart';

/// Show decorated tagged text only to be shown
///
/// [decoratedStyle] is textStyle of tagged text.
/// [basicStyle] is textStyle of others.
/// [onTap] is called when a tagged text is tapped.
class HashTagText extends StatefulWidget {
  /// Creates a [HashTagText] widget.
  HashTagText({
    Key? key,
    required this.text,
    required this.basicStyle,
    required this.decoratedStyle,
    this.decorateAtSign = false,
    this.decorateCashtag = false,
    this.customPrefixes,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.textScaler,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key);

  /// The text to display and decorate.
  final String text;

  /// The [TextStyle] applied to normal untagged text.
  final TextStyle basicStyle;

  /// The [TextStyle] applied to hashtags, mentions, or cashtags.
  final TextStyle decoratedStyle;

  /// Callback when a tag is tapped.
  final Function(String)? onTap;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// Deprecated text scale factor. Use [textScaler] instead.
  @Deprecated('Use textScaler instead.')
  final double textScaleFactor;

  /// The modern [TextScaler] used to scale text.
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text to span.
  final int? maxLines;

  /// Used to select a font when the same Unicode character can be rendered differently.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// Whether to decorate words starting with `@` (mentions).
  final bool decorateAtSign;

  /// Whether to decorate words starting with `$` (cashtags).
  final bool decorateCashtag;

  /// Optional list of custom prefix symbols to decorate.
  final List<String>? customPrefixes;

  @override
  State<HashTagText> createState() => _HashTagTextState();
}

class _HashTagTextState extends State<HashTagText> {
  late TextSpan _textSpan;

  @override
  void initState() {
    super.initState();
    _textSpan = _buildSpan();
  }

  @override
  void didUpdateWidget(covariant HashTagText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.basicStyle != widget.basicStyle ||
        oldWidget.decoratedStyle != widget.decoratedStyle ||
        oldWidget.decorateAtSign != widget.decorateAtSign ||
        oldWidget.decorateCashtag != widget.decorateCashtag ||
        !listEquals(oldWidget.customPrefixes, widget.customPrefixes) ||
        oldWidget.onTap != widget.onTap) {
      _disposeRecognizers(_textSpan);
      _textSpan = _buildSpan();
    }
  }

  TextSpan _buildSpan() {
    return getHashTagTextSpan(
      decoratedStyle: widget.decoratedStyle,
      decorateAtSign: widget.decorateAtSign,
      decorateCashtag: widget.decorateCashtag,
      customPrefixes: widget.customPrefixes,
      basicStyle: widget.basicStyle,
      onTap: widget.onTap,
      source: widget.text,
    );
  }

  void _disposeRecognizers(InlineSpan span) {
    if (span is TextSpan) {
      span.recognizer?.dispose();
      final children = span.children;
      if (children != null) {
        for (final child in children) {
          _disposeRecognizers(child);
        }
      }
    }
  }

  @override
  void dispose() {
    _disposeRecognizers(_textSpan);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use_from_same_package
    final effectiveScaler = widget.textScaler ?? TextScaler.linear(widget.textScaleFactor);
    return RichText(
      text: _textSpan,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaler: effectiveScaler,
      maxLines: widget.maxLines,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
    );
  }
}
