import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';




class GoogleApiService{



  static  Future<List<String>> fetchSuggestions(String input)async{



    final response = await http.get(Uri.parse('${ApiConstants.googleBaseUrl}?input=$input&key=${ApiConstants.mapKey}'));
    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);
      final predictions = (jsonData['predictions'] as List<dynamic>?) ?? [];

      var suggestions = predictions
          .where((prediction) => prediction != null && prediction['description'] != null)
          .map((prediction) => prediction['description'].toString())
          .toList();

      return suggestions;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  // static Future<List<String>> fetchSuggestions(String input) async {
  //   print('hasdfa');
  //   final response = await http.get(
  //     Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?access_token=${ApiConstants.mapBoxKey}&autocomplete=true&types=place,locality,neighborhood,address'),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //
  //     // ✅ Correct key spelling: "features"
  //     final features = jsonData['features'] as List<dynamic>? ?? [];
  //
  //     var suggestions = features.map((feature) => feature['place_name'].toString()).toList();
  //
  //     return suggestions;
  //   } else {
  //     throw Exception('Failed to load suggestions');
  //   }
  // }



}