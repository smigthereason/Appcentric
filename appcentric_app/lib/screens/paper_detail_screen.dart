import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/paper.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../providers/paper_provider.dart';

class PaperDetailScreen extends StatefulWidget {
  final int paperId;

  const PaperDetailScreen({Key? key, required this.paperId}) : super(key: key);

  @override
  _PaperDetailScreenState createState() => _PaperDetailScreenState();
}

class _PaperDetailScreenState extends State<PaperDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaperProvider>(context, listen: false)
          .loadPaperDetail(widget.paperId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final paperProvider = Provider.of<PaperProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(paperProvider.currentPaper?.title ?? 'Paper Details'),
        actions: [
          if (paperProvider.error != null)
            IconButton(
              icon: const Icon(Icons.offline_bolt),
              onPressed: () {
                paperProvider.loadCachedPaper();
              },
              tooltip: 'Load cached version',
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
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        paperProvider.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => paperProvider.loadPaperDetail(widget.paperId),
                        child: const Text('Retry'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          paperProvider.loadCachedPaper();
                        },
                        child: const Text('Load Cached Version'),
                      ),
                    ],
                  ),
                )
              : paperProvider.currentPaper == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Paper not found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : _buildPaperContent(paperProvider.currentPaper!),
    );
  }

  Widget _buildPaperContent(Paper paper) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paper.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ' () - ',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  if (paper.type != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Type: ',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Total Questions: ',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Questions:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...paper.questions.map((Question question) => _buildQuestionCard(question)).toList(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Q',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ' mark',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Answers:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ...question.answers.map((Answer answer) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        answer.isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: answer.isCorrect ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              answer.answerText,
                              style: TextStyle(
                                fontSize: 14,
                                color: answer.isCorrect ? Colors.green : Colors.black87,
                                fontWeight: answer.isCorrect ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                            if (answer.explanation != null && answer.explanation!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Explanation: ',
                                style: const TextStyle(
                                    fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
          ],
        ),
      ),
    );
  }
}
