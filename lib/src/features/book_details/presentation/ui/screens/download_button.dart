import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';

class DownloadButton extends ConsumerWidget {
  final Entry entry;

  const DownloadButton({required this.entry});

  String get id => entry.id!.t.toString();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = entry.id!.t.toString();
    return ref.watch(downloadsNotifierProvider).maybeWhen(
      orElse: () {
        return _downloadButton(context);
      },
      data: (books) {
        final bookIsDownloaded =
            books.indexWhere((element) => element['id'] == id) != -1;
        if (!bookIsDownloaded) {
          return _downloadButton(context);
        }
        final book = books.firstWhere((element) => element['id'] == id);
        return TextButton(
          onPressed: () => openBook(book['path'] as String, context, ref),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Text(
            'Read Book'.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: context.theme.textTheme.titleLarge?.color ?? Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      },
    );
  }

  Widget _downloadButton(BuildContext context) => TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          DownloadAlert.show(
            context: context,
            url: entry.link![3].href!,
            name: entry.title!.t ?? '',
            image: '${entry.link![1].href}',
            id: entry.id!.t.toString(),
          );
        },
        child: Text(
          'Download'.toUpperCase(),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: context.theme.textTheme.titleLarge?.color ?? Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
      );

  Future<void> openBook(
    String path,
    BuildContext context,
    WidgetRef ref,
  ) async {
    final bookFile = File(path);
    if (bookFile.existsSync()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return EpubScreen.fromPath(filePath: path);
          },
        ),
      );
    } else {
      context.showSnackBarUsingText(
        'Could not find the book file. Please download it again.',
      );
      ref.read(downloadsNotifierProvider.notifier).deleteBook(id);
    }
  }
}