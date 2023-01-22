import 'package:flutter/material.dart';
import 'package:search_demo/search/add_user_to_search.dart';
import 'package:search_demo/search/search_users.dart';

void main() {
  runApp(const SearchDemoApp());
}

class SearchDemoApp extends StatelessWidget {
  const SearchDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter search demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple.shade900,
      ),
      home: const SearchDemoPage(title: 'Flutter search demo'),
    );
  }
}

class SearchDemoPage extends StatefulWidget {
  const SearchDemoPage({super.key, required this.title});

  final String title;

  @override
  State<SearchDemoPage> createState() => _SearchDemoPageState();
}

class _SearchDemoPageState extends State<SearchDemoPage> {
  late final TextEditingController queryController;

  @override
  void initState() {
    super.initState();
    queryController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SearchBar(
                queryController: queryController,
                textChangeCallBack: () {
                  setState(() {});
                }),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your search results will be appeared here...',
              ),
            ),
            SearchResults(query: queryController.text),
          ],
        ),
      ),
      floatingActionButton: const AddRandomUserToSearchDatabaseFloatingButton(),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.queryController,
    required this.textChangeCallBack,
  });

  final TextEditingController queryController;
  final Function textChangeCallBack;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: ((_) => widget.textChangeCallBack()),
        controller: widget.queryController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search users with name and email...',
        ),
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: searchUsers(query),
        builder: (context, searchResult) {
          if (searchResult.data == null) return const SizedBox();

          return Scrollbar(
              child: ListView.separated(
            itemCount: searchResult.data!.length,
            itemBuilder: (context, index) {
              final result = searchResult.data![index];

              return ListTile(
                title: Text("${result.firstName} ${result.lastName}"),
                subtitle: Text(result.email ?? ''),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ));
        },
      ),
    );
  }
}

class AddRandomUserToSearchDatabaseFloatingButton extends StatelessWidget {
  const AddRandomUserToSearchDatabaseFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final savedSearchItem = await addUserToSearch();

        final message =
            "${savedSearchItem.firstName ?? ''} ${savedSearchItem.lastName} ${savedSearchItem.email}";

        final snackBar = SnackBar(
          content: Text(message),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      tooltip: 'Add new item',
      child: const Icon(Icons.add),
    );
  }
}
