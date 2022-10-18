import 'package:alga/constants/import_helper.dart';

part './uri_provider.dart';

class UriEncoderDecoderView extends StatelessWidget {
  const UriEncoderDecoderView({super.key});
  @override
  Widget build(BuildContext context) {
    return ScrollableToolView(
      title: Text(S.of(context).encoderDecoderURL),
      children: [
        ToolViewWrapper(
          children: [
            ToolViewConfig(
              leading: const Icon(Icons.swap_horiz_sharp),
              title: Text(S.of(context).conversion),
              subtitle: Text(S.of(context).selectConversion),
              trailing: Consumer(builder: (context, ref, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ref.watch(_isEncode)
                        ? Text(S.of(context).encode)
                        : Text(S.of(context).decode),
                    Switch(
                      value: ref.watch(_isEncode),
                      onChanged: (state) {
                        ref.read(_isEncode.notifier).state = state;
                      },
                    ),
                  ],
                );
              }),
            ),
            ToolViewConfig(
              leading: const Icon(Icons.link_rounded),
              title: Text(S.of(context).uriType),
              trailing: Consumer(builder: (context, ref, _) {
                return PopupMenuButton<UriEncodeType>(
                  itemBuilder: (context) => UriEncodeType.values
                      .map((e) => PopupMenuItem(
                          value: e, child: Text(e.getName(context))))
                      .toList(),
                  onSelected: (state) {
                    ref.read(_type.notifier).update((_) => state);
                  },
                  initialValue: ref.read(_type),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(ref.watch(_type).getName(context)),
                  ),
                );
              }),
            ),
          ],
        ),
        AppTitleWrapper(
          title: S.of(context).input,
          actions: [
            PasteButton(onPaste: (ref, data) {
              ref.read(_input).text = data;
              ref.refresh(_result);
            }),
            Consumer(builder: (context, ref, _) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  ref.read(_input).clear();
                  ref.refresh(_result);
                },
              );
            }),
          ],
          child: Consumer(builder: (context, ref, _) {
            return TextField(
              maxLines: 12,
              minLines: 2,
              controller: ref.watch(_input),
              onChanged: (_) {
                ref.refresh(_result);
              },
            );
          }),
        ),
        AppTitleWrapper(
          title: S.of(context).output,
          actions: [
            CopyButton(onCopy: (ref) => ref.read(_result)),
          ],
          child: Consumer(builder: (context, ref, _) {
            return AppTextField(
              maxLines: 12,
              minLines: 2,
              text: ref.watch(_result),
            );
          }),
        ),
      ],
    );
  }
}
