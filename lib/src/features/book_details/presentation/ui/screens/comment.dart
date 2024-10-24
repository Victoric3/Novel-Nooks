import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/roundedMessageInput.dart';

class CommentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.60, // Default height
      minChildSize: 0.50, // Minimum height when dragged down
      maxChildSize: 0.90, // Maximum height when dragged up
      builder: (context, scrollController) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: Column(
            children: [
              // Drag Indicator
              Container(
                height: 5.0,
                width: 50.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // Comments List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(comment: comments[index]);
                  },
                ),
              ),
              // Message Input Bar
              MessageInputBar(),
            ],
          ),
        );
      },
    );
  }

  final List<Comment> comments = [
    Comment(
      username: 'User1',
      text: 'This is a great video!',
      upvotes: 12,
      downvotes: 1,
      replies: [
        Comment(username: 'User2', text: 'I agree!', upvotes: 5, downvotes: 0, replies: []),
        Comment(username: 'User3', text: 'Absolutely amazing!', upvotes: 3, downvotes: 0, replies: []),
      ],
    ),
    Comment(
      username: 'User4',
      text: 'Thanks for sharing!',
      upvotes: 8,
      downvotes: 2,
      replies: [
        Comment(username: 'User5', text: 'You\'re welcome!', upvotes: 2, downvotes: 0, replies: []),
      ],
    ),
    Comment(
      username: 'User6',
      text: 'This helped me a lot, thank you!',
      upvotes: 10,
      downvotes: 1,
      replies: [],
    ),
  ];
}

class Comment {
  final String username;
  final String text;
  final int upvotes;
  final int downvotes;
  final List<Comment> replies;

  Comment({required this.username, required this.text, required this.upvotes, required this.downvotes, required this.replies});
}

class CommentWidget extends StatefulWidget {
  final Comment comment;

  const CommentWidget({super.key, required this.comment});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment Header
          Row(
            children: [
              CircleAvatar(
                child: Text(widget.comment.username[0]),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.comment.username, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.comment.text),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Comment Actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_alt_outlined),
                onPressed: () {},
              ),
              Text('${widget.comment.upvotes}'),
              IconButton(
                icon: const Icon(Icons.thumb_down_alt_outlined),
                onPressed: () {},
              ),
              Text('${widget.comment.downvotes}'),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // Handle reply
                },
                child: const Text('Reply'),
              ),
            ],
          ),
          // Show/Hide Replies
          if (widget.comment.replies.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  showReplies = !showReplies;
                });
              },
              icon: Icon(
                showReplies ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 18,
              ),
              label: Text(showReplies ? 'Hide Replies' : 'View Replies'),
            ),
          if (showReplies)
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 8.0),
              child: Column(
                children: widget.comment.replies.map((reply) => CommentWidget(comment: reply)).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
