import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/api.dart';
import '../core/routes.dart';
import '../core/audio_provider.dart';
import '../widgets/surah_tile.dart';
import '../widgets/global_mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allSurahs = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    setState(() => _loading = true);
    final data = await ApiService.fetchSurahs();
    setState(() {
      _allSurahs = data;
      _filtered = data;
      _loading = false;
    });
  }

  void _onSearch(String text) {
    setState(() {
      _filtered = _allSurahs.where((s) {
        final nameLatin = (s['name']?['transliteration']?['id'] ?? '').toString().toLowerCase();
        return nameLatin.contains(text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context, listen: false);

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
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
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
                const Icon(Icons.search, color: Colors.teal, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: _onSearch,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'Cari surah...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List surah
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final s = _filtered[i];
                        final number = s['number'] ?? 0;
                        final nameLatin = s['name']?['transliteration']?['id'] ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SurahTile(
                            number: number,
                            nameLatin: nameLatin,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.viewSurah,
                                arguments: number,
                              );
                            },
                            onPlay: () async {
                              final detail = await ApiService.fetchSurahDetail(number);
                              final verses = (detail['verses'] as List).cast<Map<String, dynamic>>();
                              if (verses.isNotEmpty) {
                                final urls = verses
                                    .map((v) => v['audio']?['primary']?.toString() ?? '')
                                    .where((url) => url.isNotEmpty)
                                    .toList();
                                if (urls.isNotEmpty) {
                                  audio.playFullSurah(urls, nameLatin);
                                }
                              }
                            },
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