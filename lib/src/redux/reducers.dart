import 'package:flutter_gitverse/src/redux/github_actions.dart';
import 'package:flutter_gitverse/src/model/app_state.dart';
import '../../config.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

final authToken = AppConfig.githubAuthToken;
Future<Map<String, dynamic>> fetchUserDetails(
    String username) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/users/$username'),
    headers: <String, String>{
      'Authorization': 'Bearer $authToken', 
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user details');
  }
}

Future<List<Map<String, dynamic>>> fetchUserRepositories(
    String username) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/users/$username/repos'),
    headers: <String, String>{
      'Authorization': 'Bearer $authToken', 
    },
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load user repositories');
  }
}

AppState appReducer(AppState state, dynamic action) {
  if (action is SearchGithubUserAction) {
    return state;
  }

  if (action is SetGithubUserAction) {
    return AppState.fromAppState(state)..userName = action.user;
  }

  if (action is SetRepositoriesAction) {
    return AppState.fromAppState(state)
      ..githubRepositories = action.repositories;
  }

  if (action is SetRecentSearchesAction) {
    final updatedSearches =
        List<Map<String, dynamic>>.from(state.recentSearches);
    final userDetails =
        action.searches.first; 
    final existingIndex = updatedSearches.indexWhere((searchResult) =>
        searchResult['login'] ==
        userDetails[
            'login']); 

    if (existingIndex != -1) {
      updatedSearches.removeAt(existingIndex);
    }

    updatedSearches.add(userDetails); 
    return AppState.fromAppState(state)..recentSearches = updatedSearches;
  }

  if (action is SetUserDetailsAction) {
    return AppState.fromAppState(state)..userDetails = action.userDetails;
  }

  return state;
}
