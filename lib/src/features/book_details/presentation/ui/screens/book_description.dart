import 'dart:ui'; // Needed for the blur effect

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/categort_chips.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/comment_rating.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/download_button.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BookDescriptionSection extends StatefulWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;

  const BookDescriptionSection({
    required this.entry,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
    Key? key,
  }) : super(key: key);

  @override
  _BookDescriptionSectionState createState() => _BookDescriptionSectionState();
}

class _BookDescriptionSectionState extends State<BookDescriptionSection> {
  bool isRatingVisible = false;
  int selectedRating = 0;

  void toggleRatingVisibility() {
    setState(() {
      isRatingVisible = !isRatingVisible;
    });
    print("Rating visibility toggled");
  }

  void selectRating(int rating) {
    setState(() {
      selectedRating = rating;
      isRatingVisible = false;
    });
    print('User rated: $rating');
  }

  void closeOverlay() {
    setState(() {
      isRatingVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.imgTag,
                  child: CachedNetworkImage(
                    imageUrl: '${widget.entry.link![1].href}',
                    placeholder: (context, url) => const SizedBox(
                      height: 200.0,
                      width: 130.0,
                      child: LoadingWidget(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Feather.x),
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: 130.0,
                  ),
                ),
                const SizedBox(width: 20.0),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 5.0),
                      Hero(
                        tag: widget.titleTag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            widget.entry.title!.t!.replaceAll(r'\', ''),
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Hero(
                        tag: widget.authorTag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '${widget.entry.author!.name!.t}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      CategoryChips(entry: widget.entry),
                      DownloadButton(entry: widget.entry),
                      CommentRatingButton(
                        currentRating: 4.5,
                        numberOfRaters: 56,
                        numberOfComments: 30,
                        toggleRatingVisibility: toggleRatingVisibility,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        if (isRatingVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: closeOverlay,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        if (isRatingVisible)
          Center(
            child: Material(
              elevation: 4,
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      onPressed: closeOverlay,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: lightAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 1; i <= 5; i++)
                          IconButton(
                            icon: Icon(
                              i <= selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: i <= selectedRating
                                  ? Colors.yellow
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              selectRating(i);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
