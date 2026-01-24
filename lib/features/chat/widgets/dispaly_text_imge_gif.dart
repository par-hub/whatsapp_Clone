import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/utils/enums/message_enums.dart';
import 'package:whatsapp/features/chat/widgets/video_item.dart';

class DispalyTextImgeGif extends StatelessWidget {
  final String message;
  final MessageEnums type;
  const DispalyTextImgeGif(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnums.text
        ? Text(
            message,
            style: TextStyle(fontSize: 16),
          )
        : type == MessageEnums.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(
                          () {
                            isPlaying = false;
                          },
                        );
                      } else {
                        await audioPlayer.play(UrlSource(message));
                        setState(
                          () {
                            isPlaying = true;
                          },
                        );
                      }
                    },
                    icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle));
              })
            : type == MessageEnums.video
                ? VideoItem(
                    videoUrl: message,
                  )
                : type == MessageEnums.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Text('GIF failed to load'),
                      )
                    : CachedNetworkImage(imageUrl: message);
  }
}
