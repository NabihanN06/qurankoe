import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AyahTile extends StatelessWidget {
  final int numberInSurah;
  final String textArabic;
  final String? translationId;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const AyahTile({
    super.key,
    required this.numberInSurah,
    required this.textArabic,
    this.translationId,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nomor ayat + tombol play
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    '$numberInSurah',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: Colors.teal,
                    size: 28,
                  ),
                  onPressed: onPlayPause,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Teks Arab dengan font Amiri
            Text(
              textArabic,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 24,
                height: 2.0,
              ),
            ),
            const SizedBox(height: 8),

            // Terjemahan
            if (translationId != null)
              Text(
                translationId!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
          ],
        ),
      ),
    );
  }
}