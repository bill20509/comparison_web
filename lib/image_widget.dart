import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.url, {
    Key? key,
  }) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: Image.network(
        url,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, loading) =>
            const CircularProgressIndicator(),
        errorBuilder: (context, exception, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}
