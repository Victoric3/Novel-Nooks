import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/comment.dart';

// ignore: must_be_immutable
class CommentRatingButton extends StatefulWidget {
  final double currentRating;
  final int numberOfRaters;
  final int numberOfComments;
  final VoidCallback toggleRatingVisibility;

  const CommentRatingButton({
    required this.currentRating,
    required this.numberOfRaters,
    required this.numberOfComments,
    required this.toggleRatingVisibility,
  });

  @override
  _CommentRatingButtonState createState() => _CommentRatingButtonState();
}

class _CommentRatingButtonState extends State<CommentRatingButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  isDismissible:
                      true,
                  builder: (context) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors
                          .transparent,
                      child: GestureDetector(
                        onTap:
                            () {},
                        child: CommentSection(),
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.comment),
              label: Text(
                '${widget.numberOfComments}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                widget.toggleRatingVisibility();
              },
              icon: const Icon(Icons.star_border),
              label: Text(
                '${widget.currentRating.toStringAsFixed(1)} (${widget.numberOfRaters})',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
