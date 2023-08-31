import 'package:flutter/material.dart';
import 'package:flutter_crawl/models/manga/manga_list.dart';

class MangaDialog extends StatelessWidget {
  final MangaListDetailModel item;

  const MangaDialog({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Wrap(
                  spacing: 8,
                  children: item.tags.map((e) {
                    return ActionChip(
                      label: Text(e.name),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 2,
                      ),
                      onPressed: () {},
                    );
                  }).toList(),
                ),
              ),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
