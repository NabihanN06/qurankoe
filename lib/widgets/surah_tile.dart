import 'package:flutter/material.dart';

class SurahTile extends StatelessWidget {
  final int number;
  final String nameLatin;
  final VoidCallback onTap;
  final VoidCallback onPlay;

  const SurahTile({
    super.key,
    required this.number,
    required this.nameLatin,
    required this.onTap,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Text(
                  '$number',
                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  nameLatin,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.teal),
                onPressed: onPlay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}