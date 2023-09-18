// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gitverse/src/redux/reducers.dart';
import 'package:flutter_gitverse/src/screens/user_details.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../model/app_state.dart';
import '../redux/github_actions.dart';
import '../widgets/cards.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final userNameController = TextEditingController();
    final recentSearches = store.state.recentSearches;

    Future<void> handleSearch() async {
      final username = userNameController.text;
      try {
        await store.dispatch(searchGithubUser(username));
        final userData = store.state.userDetails;
        store.dispatch(SetGithubUserAction(username));
        print(store.state.recentSearches);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(
              username: username,
            ),
          ),
        );
      } catch (e) {
        print(e);
        // Handle errors here, e.g., show an error dialog.
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('GitVerse'),centerTitle: true,),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              'https://icon-library.com/images/github-icon-white/github-icon-white-6.jpg',
              height: 75,
              width: 75,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: userNameController,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                onPressed: handleSearch,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Search Github Profile'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StoreConnector<AppState, List<Map<String, dynamic>>>(
                converter: (store) => store.state.recentSearches,
                builder: (context, recentSearches) {
                  print("Recent Searches: $recentSearches");
                  print(store.state.userDetails);
                  print(store.state.githubRepositories);

                  final reversedSearches = recentSearches.reversed.toList();
                  return ListView.builder(
                    itemCount: reversedSearches.length,
                    itemBuilder: (context, index) {
                      final searchResult = reversedSearches[index];
                      return GestureDetector(
                        onTap: () async {
                          final userDetails = searchResult;
                          store.dispatch(
                              SetGithubUserAction(userDetails['login']));
                          final repositories =
                              await fetchUserRepositories(userDetails["login"]);
                          store.dispatch(SetRepositoriesAction(repositories));
                          store.dispatch(SetUserDetailsAction(userDetails));

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserDetailsScreen(
                                username: userDetails['login'],
                              ),
                            ),
                          );
                        },
                        child: UserCard(
                            name: searchResult['name'] ?? searchResult['login'],
                            followers: searchResult['followers'],
                            url: searchResult['avatar_url'],
                            location: searchResult['location'] ?? 'Unknown'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

