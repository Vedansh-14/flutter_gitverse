import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget {
  final String name;
  final int followers;
  final String url;
  final String location;

  const UserCard({
    required this.name,
    required this.followers,
    required this.url,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
        title: Text(
          'Name: $name',
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Followers: $followers',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
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
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(cloneUrl);

                if (await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
              },
              child: Text(
                'Clone Repository: Click Here',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors
                      .blue, // Change the color to indicate it's clickable
                  decoration:
                      TextDecoration.underline, // Add underline for indication
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
