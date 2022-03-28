import 'package:alga/l10n/l10n.dart';
import 'package:alga/utils/clipboard_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasteButton extends StatelessWidget {
  final Function(WidgetRef ref, String data) onPaste;
  const PasteButton({Key? key, required this.onPaste}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return IconButton(
          onPressed: () async {
            onPaste(ref, await ClipboardUtil.paste());
          },
          icon: child!,
          tooltip: S.of(context).paste,
        );
      },
      child: const Icon(Icons.paste),
    );
  }
}
