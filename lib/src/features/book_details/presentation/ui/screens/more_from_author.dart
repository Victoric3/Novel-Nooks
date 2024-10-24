import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/book_details/book_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreBooksFromAuthor extends ConsumerStatefulWidget {
  final String authorUrl;
  final Entry entry;

  const MoreBooksFromAuthor({
    required this.authorUrl,
    required this.entry,
  });

  @override
  ConsumerState<MoreBooksFromAuthor> createState() =>
      MoreBooksFromAuthorState();
}

class MoreBooksFromAuthorState extends ConsumerState<MoreBooksFromAuthor> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookDetailsNotifierProvider(widget.authorUrl).notifier).fetch();
    });
  }

  @override
  void didUpdateWidget(covariant MoreBooksFromAuthor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authorUrl != widget.authorUrl) {
      _fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(bookDetailsNotifierProvider(widget.authorUrl)).maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const LoadingWidget(),
          data: (related) {
            if (related.feed!.entry == null || related.feed!.entry!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Empty',
                  ),
                ),
              );
            }
            final entries = related.feed!.entry!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: related.feed!.entry!.length,
              itemBuilder: (BuildContext context, int index) {
                final entry = entries[index];
                final isSingleEntry = entries.length == 1;
                if (entry.id!.t == widget.entry.id!.t && isSingleEntry) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Text(
                        "oops, there's no other book from this author available",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (entry.id!.t == widget.entry.id!.t) {
                  return const SizedBox
                      .shrink(); // Skip rendering the current entry
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: BookListItem(entry: entry),
                  );
                }
              },
            );
          },
          error: (_, __) {
            return MyErrorWidget(
              refreshCallBack: () => _fetch(),
            );
          },
        );
  }
}