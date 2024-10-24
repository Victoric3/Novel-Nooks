import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/book_description.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/more_from_author.dart';
import 'package:flutter_ebook_app/src/features/book_details/presentation/ui/screens/section_title.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class BookDetailsScreen extends ConsumerStatefulWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;

  const BookDetailsScreen({
    super.key,
    required this.entry,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
  });

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final autoRouteTopRoute = context.watchRouter.currentChild;
    final canPop = context.router.canPop();

    return Scaffold(
        appBar: AppBar(
          leading: !canPop && autoRouteTopRoute?.name == 'BookDetailsRoute'
              ? CloseButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          backgroundColor: context.isSmallScreen ? null : Colors.transparent,
          actions: <Widget>[
            ref.watch(favoritesNotifierProvider).maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  data: (favorites) {
                    final favorited = favorites.indexWhere(
                          (element) => element.id!.t == widget.entry.id!.t,
                        ) !=
                        -1;
                    return IconButton(
                      onPressed: () async {
                        if (favorited) {
                          ref
                              .watch(favoritesNotifierProvider.notifier)
                              .deleteBook(widget.entry.id!.t ?? '');
                        } else {
                          ref
                              .watch(favoritesNotifierProvider.notifier)
                              .addBook(widget.entry, widget.entry.id!.t ?? '');
                        }
                      },
                      icon: Icon(
                        favorited ? Icons.favorite : Feather.heart,
                        color: favorited
                            ? Colors.red
                            : context.theme.iconTheme.color,
                      ),
                    );
                  },
                ),
            IconButton(
              onPressed: () => _share(),
              icon: const Icon(Feather.share),
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                const SizedBox(height: 10.0),
                BookDescriptionSection(
                  entry: widget.entry,
                  authorTag: widget.authorTag,
                  imgTag: widget.imgTag,
                  titleTag: widget.titleTag,
                ),
                const SizedBox(height: 30.0),
                const SectionTitle(title: 'Book Description'),
                const _Divider(),
                const SizedBox(height: 10.0),
                DescriptionTextWidget(text: '${widget.entry.summary!.t}'),
                const SizedBox(height: 30.0),
                const SectionTitle(
                  title: 'More from Author',
                ),
                const _Divider(),
                const SizedBox(height: 10.0),
                MoreBooksFromAuthor(
                  authorUrl:
                      widget.entry.author!.uri!.t!.replaceAll(r'\&lang=en', ''),
                  entry: widget.entry,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
            // CommentSection()
          ],
        ));
  }

  void _share() {
    Share.share('${widget.entry.title!.t} by ${widget.entry.author!.name!.t}'
        'Read/Download ${widget.entry.title!.t} from ${widget.entry.link![3].href}.');
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(color: context.theme.textTheme.bodySmall!.color);
  }
}
