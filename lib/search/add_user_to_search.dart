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
