import 'package:alga/widgets/app_scaffold.dart';
import 'package:alga/widgets/copy_button_widget.dart';
import 'package:alga/widgets/paste_button_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown/markdown.dart' show markdownToHtml;

import 'package:alga/constants/import_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

part './markdown_preview_provider.dart';

class MarkdownPreviewView extends ConsumerStatefulWidget {
  const MarkdownPreviewView({super.key});

  @override
  ConsumerState<MarkdownPreviewView> createState() =>
      _MarkdownPreviewViewState();
}

class _MarkdownPreviewViewState extends ConsumerState<MarkdownPreviewView> {
  @override
  Widget build(BuildContext context) {
    final bool small = isSmallDevice(context);
    final editable = AppTitleWrapper(
      title: S.of(context).markdownInput,
      expand: !small,
      actions: [
        PasteButtonWidget(
          _inputController,
          onUpdate: (ref) => ref.refresh(_inputValue),
        ),
      ],
      child: Consumer(builder: (context, ref, _) {
        return LanguageTextField(
          expands: !small,
          maxLines: small ? 16 : null,
          minLines: small ? 16 : null,
          controller: ref.watch(_inputController),
          onChanged: (_) => ref.refresh(_inputValue),
        );
      }),
    );
    final preview = AppTitleWrapper(
      title: S.of(context).markdownPreviewInput,
      expand: !small,
      actions: [
        CopyButtonWithText(_inputValue),
      ],
      child: Consumer(builder: (context, ref, _) {
        final data = ref.watch(_inputValue);
        void onTapLink(text, href, title) {
          if (href != null) {
            launchUrlString(
              href,
              mode: LaunchMode.externalApplication,
            );
          }
        }

        if (isSmallDevice(context)) {
          return MarkdownBody(
              data: data, selectable: true, onTapLink: onTapLink);
        } else {
          return Markdown(
            data: data,
            selectable: true,
            onTapLink: onTapLink,
          );
        }
      }),
    );

    return AppScaffold(
      title: Text(S.of(context).markdownPreview),
      first: editable,
      second: preview,
    );
  }
}
