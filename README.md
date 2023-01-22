Flutter Stockholm 24 January 2023 - Full Text Search Talk

Meili setup

```
brew update && brew install meilisearch
```

Run meili on your local machine

```
meilisearch
```

Set up api-key

```
curl \                                                                                                                                                                   21:13:05
   -X POST 'http://localhost:7700/indexes/patient_medical_records/search' \
   -H 'Authorization: Bearer search-demo'
```

Add meilisearch to flutter

```
// Warning!: There was a issue with 0.7.0 version. 
dependencies:
  meilisearch: ^0.6.0
```

Flutter implementation for adding fake user data

```dart
import 'package:faker/faker.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:search_demo/model/search_result_model.dart';

Future<SearchResultModel> addUserToSearch() async {
  const serverUrl = 'http://localhost:7700';
  const apiKey = 'search-demo';

  final client = MeiliSearchClient(serverUrl, apiKey);

  final faker = Faker();

  final id = faker.randomGenerator.numberOfLength(20);
  final firstName = faker.person.firstName();
  final lastName = faker.person.lastName();
  final email = faker.internet.email();

  await client.index('users').addDocuments([
    {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
    }
  ]);

  return SearchResultModel(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
  );
}
```

Search query from flutter

```dart
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
```
