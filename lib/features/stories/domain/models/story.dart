/// Data model for a single Nepali story.
class NepaliStory {
  final String id;
  final String titleNepali;
  final String titleEnglish;
  final String emoji;
  final String coverColor; // hex
  final String coverColorEnd; // hex for gradient
  final String description;
  final List<StoryParagraph> paragraphs;
  final int estimatedMinutes;

  const NepaliStory({
    required this.id,
    required this.titleNepali,
    required this.titleEnglish,
    required this.emoji,
    required this.coverColor,
    required this.coverColorEnd,
    required this.description,
    required this.paragraphs,
    required this.estimatedMinutes,
  });

  /// All sentences flattened in order (used for TTS narration)
  List<String> get allSentences =>
      paragraphs.expand((p) => p.sentences).toList();

  /// Full text for display
  String get fullText =>
      paragraphs.map((p) => p.sentences.join(' ')).join('\n\n');
}

class StoryParagraph {
  final List<String> sentences;
  const StoryParagraph(this.sentences);
}
