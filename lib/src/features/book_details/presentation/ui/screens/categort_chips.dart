import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';

class CategoryChips extends StatelessWidget {
  final Entry entry;

  const CategoryChips({required this.entry});

  @override
  Widget build(BuildContext context) {
    if (entry.category == null) {
      return const SizedBox.shrink();
    } else {
      return Wrap(
        children: [
          ...entry.category!.map((category) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7.0,
                    vertical: 5,
                  ),
                  child: Text(
                    '${category.label}',
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      );
    }
  }
}