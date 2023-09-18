import 'package:flutter_gitverse/src/redux/github_actions.dart';
import 'package:flutter_gitverse/src/model/app_state.dart';

import 'package:fluttertoast/fluttertoast.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchUserDetails(String username) async {
  final response = await http.get(Uri.parse('https://api.github.com/users/$username'));
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user details');
    
  }
}

Future<List<Map<String, dynamic>>> fetchUserRepositories(String username) async {
  final response = await http.get(Uri.parse('https://api.github.com/users/$username/repos'));
  
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
    return AppState.fromAppState(state)..githubRepositories = action.repositories;
  }

if (action is SetRecentSearchesAction) {
  final updatedSearches = List<Map<String, dynamic>>.from(state.recentSearches);
  updatedSearches.addAll(action.searches);
  return AppState.fromAppState(state)..recentSearches = updatedSearches;
}


  if (action is SetUserDetailsAction) {
    return AppState.fromAppState(state)..userDetails = action.userDetails;
  }

  return state;
}
