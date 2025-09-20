import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  String _currentTitle = '';
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<String> _playlist = [];
  int _currentIndex = 0;
  String _surahTitle = '';
  bool _isFullSurahMode = false;

  // Getters
  String get currentTitle => _currentTitle;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isFullSurahMode => _isFullSurahMode;
  int get currentAyahNumber => _currentIndex + 1;
  String get surahTitle => _surahTitle;

  double get currentProgress =>
      _duration.inMilliseconds == 0 ? 0 : _position.inMilliseconds / _duration.inMilliseconds;

  String get formattedPosition => _formatTime(_position);
  String get formattedDuration => _formatTime(_duration);

  AudioProvider() {
    _player.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });
    _player.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
    _player.onPlayerComplete.listen((event) {
      if (_isFullSurahMode && _playlist.isNotEmpty && _currentIndex < _playlist.length - 1) {
        _currentIndex++;
        _currentTitle = '$_surahTitle — Ayat ${_currentIndex + 1}';
        _playUrl(_playlist[_currentIndex]);
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      notifyListeners();
    });
  }

  Future<void> play(String url, String title) async {
    _playlist.clear();
    _currentIndex = 0;
    _isFullSurahMode = false;
    await _playUrl(url);
    _currentTitle = title;
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> playFullSurah(List<String> urls, String surahName) async {
    if (urls.isEmpty) return;
    _playlist = urls;
    _currentIndex = 0;
    _surahTitle = surahName;
    _isFullSurahMode = true;
    _currentTitle = '$surahName — Ayat 1';
    await _playUrl(_playlist[_currentIndex]);
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> _playUrl(String url) async {
    await _player.stop();
    await _player.play(UrlSource(url));
  }

  void pause() {
    _player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    _player.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void seek(Duration pos) {
    _player.seek(pos);
  }

  void next() {
    if (_playlist.isNotEmpty && _currentIndex < _playlist.length - 1) {
      _currentIndex++;
      _currentTitle = '$_surahTitle — Ayat ${_currentIndex + 1}';
      _playUrl(_playlist[_currentIndex]);
      _isPlaying = true;
      notifyListeners();
    }
  }

  void prev() {
    if (_playlist.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      _currentTitle = '$_surahTitle — Ayat ${_currentIndex + 1}';
      _playUrl(_playlist[_currentIndex]);
      _isPlaying = true;
      notifyListeners();
    }
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}';
  }
}