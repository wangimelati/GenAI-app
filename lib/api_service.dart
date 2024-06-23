import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://my-genai2-model-dczyyawmja-et.a.run.app';

  Future<String> getSkincareRoutine(String skinType, String skinConcerns, String currentSkincare) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'skin_type': skinType,
        'skin_concerns': skinConcerns,
        'current_skincare': currentSkincare,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['result'];
    } else {
      throw Exception('Failed to load skincare routine');
    }
  }
}
