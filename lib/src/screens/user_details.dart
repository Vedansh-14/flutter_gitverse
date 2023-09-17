// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../model/app_state.dart';
import '../redux/github_actions.dart';

class UserDetailsScreen extends StatelessWidget {
  final String username;

  UserDetailsScreen({
    required this.username,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) {
        final userDetails = store.state.userDetails;
        final repositories = store.state.githubRepositories;
        return {
          'userDetails': userDetails,
          'repositories': repositories,
        };
      },
      builder: (BuildContext context, dynamic state) {
        final userDetails = state['userDetails'];
        final repositories = state['repositories'];
        final username = userDetails['name'] ?? userDetails['login'];
        String followers = userDetails['followers'].toString();
        String following = userDetails['following'].toString();
        return Scaffold(
          appBar: AppBar(title: const Text('GitVerse'),centerTitle: true,),
          backgroundColor: Colors.black,
          body: ListView(
            children: [
              Transform.translate(
                offset: const Offset(0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(userDetails['avatar_url']),
                      ),
                      title: Text(
                        userDetails['name'] ?? username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        userDetails['bio'] ?? 'No Bio',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                                     Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Followers: $followers',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Following: $following',
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                 const SizedBox(height: 20),
                 const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Repositories',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                    // ... rest of the code ...
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 20),
                child: ListView.builder(
                  itemCount: repositories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final repository = repositories[index];
                    print(repository);
                    return RepositoryCard(
                      name: repository['name'],
                      created_at: repository['created_at'],
                      cloneUrl: repository['clone_url'],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RepositoryCard extends StatelessWidget {
  final String name;
  final String created_at;
  final String cloneUrl;

  RepositoryCard({
    required this.name,
    required this.created_at,
    required this.cloneUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: const Icon(Icons.code, color: Colors.blue),
        title: Text(
          'Name: $name',
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created on: $created_at',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Clone Repository: $cloneUrl',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.star_border),
          onPressed: () {
            // Implement your star/favorite action here
          },
        ),
      ),
    );
  }
}
