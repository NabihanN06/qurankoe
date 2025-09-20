import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchSurahs() async {
    final url = Uri.parse('${AppConfig.baseUrl}/surah');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return (body['data'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal ambil surah');
    }
  }

  static Future<Map<String, dynamic>> fetchSurahDetail(int number) async {
    final url = Uri.parse('${AppConfig.baseUrl}/surah/$number');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return body['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Gagal ambil detail surah');
    }
  }
}