import 'package:flutter/material.dart';
import '../models/issue_model.dart';

class IssueDetailScreen extends StatelessWidget {
  final Issue issue;
  const IssueDetailScreen({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(issue.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${issue.description}"),
            const SizedBox(height: 10),
            Text("Status: ${issue.status}"),
            const SizedBox(height: 10),
            issue.imageUrl.isNotEmpty
                ? Image.network(issue.imageUrl, height: 200)
                : Container(),
          ],
        ),
      ),
    );
  }
}
