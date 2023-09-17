class AppState {
  List<Map<String, dynamic>> githubRepositories = [];
  List<Map<String, dynamic>> githubUsers = [];
  Map<String, dynamic> userDetails = {};
  List<Map<String, dynamic>> recentSearches = [];
  var userName;

  AppState({
    required this.userName,
  });

  AppState.fromAppState(AppState another)
      : userName = another.userName,
        githubUsers = another.githubUsers,
        githubRepositories = another.githubRepositories,
        userDetails = another.userDetails,
        recentSearches = another.recentSearches;
}
