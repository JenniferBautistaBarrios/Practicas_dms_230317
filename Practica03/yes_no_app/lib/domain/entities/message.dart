enum FromWho { me, her }

class Message {
  final String text;
  final String? imageUrl;
  final bool isLoading;
  final FromWho fromWho;

  Message({
    required this.text,
    this.imageUrl,
    this.isLoading = false,
    required this.fromWho
  });
}
