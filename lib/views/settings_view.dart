import 'package:alga/constants/import_helper.dart';
import 'package:alga/extension/list_ext.dart';
import 'package:alga/utils/hive_adapters/system_settings_model.dart';
import 'package:alga/utils/hive_boxes/system_box.dart';
import 'package:alga/utils/hive_util.dart';
import 'package:alga/views/widgets/expandable_settings_tile.dart';
import 'package:alga/views/widgets/settings_tile.dart';
import 'package:alga/widgets/box_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return ToolView(
      title: Text(S.of(context).settings),
      content: ListView(
        children: <Widget>[
          ListTile(
            title: Text(S.of(context).about),
          ),
          SettingsTile(
            leading: Image.asset('assets/logo/256.webp', height: 32, width: 32),
            title: Text(S.of(context).appName),
          ),
          SettingsTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(S.of(context).themeMode),
            trailing: BoxBuilder(
              box: HiveUtil.systemBox,
              builder: (context, box) {
                return PopupMenuButton<ThemeMode>(
                  itemBuilder: (context) {
                    return ThemeMode.values
                        .map((e) => PopupMenuItem(
                            child: Text(e.getName(context)), value: e))
                        .toList();
                  },
                  initialValue: SystemBox.model.themeMode,
                  onSelected: (item) {
                    SystemBox.model = SystemBox.model.copyWith(themeMode: item);
                  },
                  child: Text(SystemBox.model.themeMode.getName(context)),
                );
              },
            ),
          ),
          SettingsTile(
            leading: const Icon(Icons.language),
            title: Text(S.of(context).language),
            trailing: BoxBuilder(
              box: HiveUtil.systemBox,
              builder: (context, box) {
                return PopupMenuButton<String>(
                  itemBuilder: (context) {
                    return SystemSettingsModel.localCodes.map((e) {
                      return PopupMenuItem(
                        child: Text(S.getlang(context, e)),
                        value: e,
                      );
                    }).toList();
                  },
                  initialValue: SystemBox.model.localeCode,
                  onSelected: (item) {
                    SystemBox.model =
                        SystemBox.model.copyWith(localeCode: item);
                  },
                  child: Text(S.getlang(context, SystemBox.model.localeCode)),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ExpandableSettingsTile(
            title: const Text('Links'),
            leading: const Icon(Icons.link),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.code_rounded),
                  title: const Text('github'),
                  onTap: () {
                    launch('https://github.com/laiiihz/alga');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.copyright),
                  title: const Text('LICENSES'),
                  onTap: () {
                    showLicensePage(context: context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report_rounded),
                  title: const Text('issues'),
                  onTap: () {
                    launch('https://github.com/laiiihz/alga/issues');
                  },
                ),
              ],
            ),
          ),
        ].sep(const SizedBox(height: 4)),
      ),
    );
  }
}
