import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String _title;
  final String _imageUrl;

  const UserProductItem({required String title, required String imageUrl, Key? key})
      : _title = title,
        _imageUrl = imageUrl,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(_title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_imageUrl),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
