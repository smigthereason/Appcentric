import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paper_provider.dart';

class PapersListScreen extends StatefulWidget {
  const PapersListScreen({Key? key}) : super(key: key);

  @override
  _PapersListScreenState createState() => _PapersListScreenState();
}

class _PapersListScreenState extends State<PapersListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaperProvider>(context, listen: false).loadPapers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paperProvider = Provider.of<PaperProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Papers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search Papers'),
                  content: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Enter subject or paper title...',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _searchController.clear();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        paperProvider.loadPapers(search: _searchController.text);
                        Navigator.pop(context);
                        _searchController.clear();
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => paperProvider.loadPapers(),
          ),
        ],
      ),
      body: paperProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : paperProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        paperProvider.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => paperProvider.loadPapers(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : paperProvider.papers.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No papers found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => paperProvider.loadPapers(),
                      child: ListView.builder(
                        itemCount: paperProvider.papers.length,
                        itemBuilder: (context, index) {
                          final paper = paperProvider.papers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 2,
                            child: ListTile(
                              leading: const Icon(Icons.description, color: Colors.blue),
                              title: Text(
                                paper.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' • ',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  if (paper.type != null)
                                    Text(
                                      'Type: ',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  Text(
                                    'Questions: ',
                                    style: const TextStyle(fontSize: 12, color: Colors.green),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/paper_detail',
                                  arguments: paper.id,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
