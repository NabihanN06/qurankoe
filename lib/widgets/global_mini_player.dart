import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/audio_provider.dart';

class GlobalMiniPlayer extends StatelessWidget {
  const GlobalMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context);

    if (audio.currentTitle.isEmpty) return const SizedBox();

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Icon / Cover
            CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                audio.isPlaying ? Icons.graphic_eq : Icons.music_note,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),

            // Info & Progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio.isFullSurahMode
                        ? '${audio.surahTitle} — Ayat ${audio.currentAyahNumber}'
                        : audio.currentTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: audio.currentProgress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.teal,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(audio.formattedPosition,
                          style: const TextStyle(fontSize: 10)),
                      Text(audio.formattedDuration,
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Controls
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: audio.prev,
            ),
            IconButton(
              icon: Icon(
                audio.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 32,
                color: Colors.teal,
              ),
              onPressed: () {
                audio.isPlaying ? audio.pause() : audio.resume();
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: audio.next,
            ),
          ],
        ),
      ),
    );
  }
}