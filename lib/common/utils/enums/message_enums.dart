enum MessageEnums {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageEnums(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageEnums toEnum() {
    switch (this) {
      case 'text':
        return MessageEnums.text;
      case 'image':
        return MessageEnums.image;
      case 'audio':
        return MessageEnums.audio;
      case 'video':
        return MessageEnums.video;
      case 'gif':
        return MessageEnums.gif;
      default:
        return MessageEnums.text;
    }
  }
}
