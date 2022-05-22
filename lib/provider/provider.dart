import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_api_sample/data/postal_code.dart';
import 'package:http/http.dart' as http;

// TextFieldに入力される値
final postalCodeProvider = StateProvider((ref) => '');

// 入力された値をもとにAPI通信をする
final apiProvider = FutureProvider((ref) async {
  final postalCode = ref.watch(postalCodeProvider);
  if (postalCode.length != 7) {
    throw Exception('Postal Code must be 7 characters');
  }
  // 123-4567
  final upper = postalCode.substring(0, 3); //123
  final lower = postalCode.substring(3); // 4567
  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';
  final apiUri = Uri.parse(apiUrl);
  http.Response response = await http.get(apiUri);
  if (response.statusCode != 200) {
    throw Exception('No postal code: $postalCode');
  }
  var jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});

// familyを用いることでProviderを引数として取ることができる
// familyの場合、値が変わるたびにインスタンスを返すため、autoDisposeが必須らしい
AutoDisposeFutureProviderFamily<PostalCode, String> apiFamilyProvider =
    FutureProvider.autoDispose
        .family<PostalCode, String>((ref, postalCode) async {
  if (postalCode.length != 7) {
    throw Exception('Postal Code must be 7 characters');
  }
  // 123-4567
  final upper = postalCode.substring(0, 3); //123
  final lower = postalCode.substring(3); // 4567
  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';
  final apiUri = Uri.parse(apiUrl);
  http.Response response = await http.get(apiUri);
  if (response.statusCode != 200) {
    throw Exception('No postal code: $postalCode');
  }
  var jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});
