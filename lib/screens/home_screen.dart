import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../models/issue_model.dart';
import 'report_issue_screen.dart';
import 'issue_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Prahar Issues")),
      body: StreamBuilder<List<Issue>>(
        stream: firebaseService.getIssues(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final issues = snapshot.data!;
          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              return ListTile(
                title: Text(issue.title),
                subtitle: Text(issue.status),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => IssueDetailScreen(issue: issue)));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ReportIssueScreen()));
        },
      ),
    );
  }
}
