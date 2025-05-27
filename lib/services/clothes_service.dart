import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clothes_model.dart';

class ClothesService {
  static const String baseUrl = 'https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes';

  static Future<List<Clothes>> getAllClothes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Clothes.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clothes');
    }
  }

  static Future<Clothes> getClothesById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Clothes.fromJson(data);
    } else {
      throw Exception('Clothing not found');
    }
  }

  static Future<void> createClothes(Clothes clothes) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(clothes.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<Map<String, dynamic>> updateClothes(int id, Clothes clothes) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(clothes.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<void> deleteClothes(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
