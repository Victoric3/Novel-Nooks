import 'package:flutter_ebook_app/src/common/constants/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

  const String baseURL = 'http://172.20.10.2:8000';
  const String publicDomainURL = '/story';
  final String recent = '$baseURL$publicDomainURL/recent';
  final String shortStory = '$baseURL$publicDomainURL/shortStory';
  final String sciFi = '$baseURL$publicDomainURL/sci-Fi';
  final String fantasy = '$baseURL$publicDomainURL/Fantasy';
  final String horror = '$baseURL$publicDomainURL/Horror';
  final String mystery = '$baseURL$publicDomainURL/Mystery';
  final String nonFiction = '$baseURL$publicDomainURL/Non-Fiction';
  final String historicalFiction = '$baseURL$publicDomainURL/Historical Fiction';
  final String multiGenre = '$baseURL$publicDomainURL/Multi-genre';
  final String adventure = '$baseURL$publicDomainURL/Adventure';
  final String biography = '$baseURL$publicDomainURL/Biography';
  final String science = '$baseURL$publicDomainURL/Science';
  final String selfHelp = '$baseURL$publicDomainURL/Self-Help';
  final String personalDevelopment = '$baseURL$publicDomainURL/Personal-development';


String getpopularUrl(WidgetRef ref) {
  final userData = ref.watch(userProvider);

  return '$baseURL$publicDomainURL/getAllStories/${userData!["interests"].join("+")}';
}
