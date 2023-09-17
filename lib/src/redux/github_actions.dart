import 'package:flutter_gitverse/src/model/app_state.dart';
import 'package:flutter_gitverse/src/redux/reducers.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

class SearchGithubUserAction {
  final String searchText;

  SearchGithubUserAction(this.searchText);
}

class SetGithubUserAction {
  final String user;

  SetGithubUserAction(this.user);
}

class SetRecentSearchesAction {
  final List<Map<String, dynamic>> searches;

  SetRecentSearchesAction(this.searches);
}


ThunkAction<AppState> searchGithubUser(String username) {
  return (Store<AppState> store) async {
    try {
      // Fetch user details
      var userDetails = await fetchUserDetails(username);
      print(userDetails);
      // Fetch user repositories
      var repositories = await fetchUserRepositories(username);
      print(repositories);
      // Dispatch actions to update the state
      store.dispatch(SetGithubUserAction(username));
      store.dispatch(SetRecentSearchesAction([userDetails]));
      store.dispatch(SetRepositoriesAction(repositories));
      store.dispatch(SetUserDetailsAction(userDetails));
    } catch (e) {
      print(e);
    }
  };
}

class SetUserDetailsAction {
  final Map<String, dynamic> userDetails;

  SetUserDetailsAction(this.userDetails);
}

class SetRepositoriesAction {
  final List<Map<String, dynamic>> repositories;

  SetRepositoriesAction(this.repositories);
}
