import 'package:meilisearch/meilisearch.dart';
import 'package:search_demo/model/search_result_model.dart';

Future<List<SearchResultModel>> searchUsers(String searchText) async {
  try {
    const serverUrl = 'http://localhost:7700';
    const apiKey = 'search-demo';

    final client = MeiliSearchClient(serverUrl, apiKey);

    final searchResult = await client.index('users').search(searchText);

    if (searchResult.hits == null || searchResult.hits!.isEmpty) return [];

    return searchResult.hits!
        .map((hit) => SearchResultModel(
              id: hit['id'],
              firstName: hit['firstName'],
              lastName: hit['lastName'],
              email: hit['email'],
            ))
        .toList();
  } catch (e) {
    // ignore: avoid_print
    print(e);
    return [];
  }
}
