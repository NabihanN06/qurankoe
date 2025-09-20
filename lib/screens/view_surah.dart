import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/api.dart';
import '../core/audio_provider.dart';
import '../widgets/global_mini_player.dart';

class ViewSurahScreen extends StatefulWidget {
  final int surahNumber;
  const ViewSurahScreen({super.key, required this.surahNumber});

  @override
  State<ViewSurahScreen> createState() => _ViewSurahScreenState();
}

class _ViewSurahScreenState extends State<ViewSurahScreen> {
  Map<String, dynamic>? _surah;
  List<Map<String, dynamic>> _verses = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final data = await ApiService.fetchSurahDetail(widget.surahNumber);
      if (!mounted) return;
      setState(() {
        _surah = data;
        _verses = (data['verses'] as List).cast<Map<String, dynamic>>();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context, listen: false);
    final nameLatin = _surah?['name']?['transliteration']?['id'] ?? '';
    final revelation = _surah?['revelation']?['id'] ?? '';
    final number = _surah?['number'] ?? widget.surahNumber;

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          'QURANKOE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Info surah
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nameLatin,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Surah ke-$number • $revelation',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill,
                      size: 36, color: Colors.teal),
                  tooltip: 'Putar Seluruh Surah',
                  onPressed: () {
                    if (_verses.isNotEmpty) {
                      final urls = _verses
                          .map((v) => v['audio']?['primary']?.toString() ?? '')
                          .where((url) => url.isNotEmpty)
                          .toList();
                      audio.playFullSurah(urls, nameLatin);
                    }
                  },
                ),
              ],
            ),
          ),

          // List ayat
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                      ? Center(child: Text('Error: $_error'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _verses.length,
                          itemBuilder: (context, i) {
                            final v = _verses[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Nomor ayat + tombol play
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.teal.shade100,
                                            child: Text(
                                              '${v['number']?['inSurah'] ?? i + 1}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.play_circle_fill,
                                              color: Colors.teal,
                                              size: 28,
                                            ),
                                            onPressed: () {
                                              final audioUrl =
                                                  v['audio']?['primary'] ?? '';
                                              if (audioUrl.isNotEmpty) {
                                                audio.play(
                                                  audioUrl,
                                                  '$nameLatin — Ayat ${v['number']?['inSurah']}',
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Teks Arab dengan font Amiri
                                      Text(
                                        v['text']?['arab'] ?? '',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.amiri(
                                          fontSize: 24,
                                          height: 2.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Terjemahan
                                      if (v['translation']?['id'] != null)
                                        Text(
                                          v['translation']?['id'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),

          // Footer dinamis
          Consumer<AudioProvider>(
            builder: (context, audio, _) {
              if (audio.currentTitle.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.teal,
                  child: const Text(
                    'Jangan lupa mengaji setiap hari',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              } else {
                return const GlobalMiniPlayer();
              }
            },
          ),
        ],
      ),
    );
  }
}