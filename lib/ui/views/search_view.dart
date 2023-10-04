import 'dart:ui';

import 'package:alga/ui/alga_view/all_apps/alga_app_item.dart';
import 'package:alga/utils/constants/import_helper.dart';
import 'package:alga/models/app_atom.dart';
import 'package:alga/ui/widgets/asset_svg.dart';
import 'package:go_router/go_router.dart';

class SearchRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchView();
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _textController = TextEditingController();

  List<AppAtom> _items = <AppAtom>[];

  @override
  void initState() {
    super.initState();
    _items = _findAtom(_textController.text);

    _textController.addListener(() {
      _items = _findAtom(_textController.text);
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  List<AppAtom> _findAtom(String query) {
    if (query.isEmpty) return AppAtom.items.toList();
    query = query.toLowerCase();
    final results = <AppAtom>{};

    for (var element in AppAtom.items) {
      if (element.path.contains(query)) {
        results.add(element);
      }
      if (element.title(context).contains(query)) {
        results.add(element);
      }
    }
    return results.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: const Text('搜索')),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchPersistentHeader(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  autofocus: true,
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: context.tr.search,
                  ),
                ),
              ),
            ),
          ),
          if (_items.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _items[index];
                    return AlgaAppItem(item);
                  },
                  childCount: _items.length,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1.618,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
              ),
            ),
          if (_items.isEmpty)
            const SliverToBoxAdapter(
              child: AssetSvg('assets/images/not_found.svg'),
            ),
        ],
      ),
    );
  }
}

class _SearchPersistentHeader extends SliverPersistentHeaderDelegate {
  const _SearchPersistentHeader({required this.child});

  final Widget child;
  static const double _kHeight = 84;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Theme.of(context).colorScheme.background.withOpacity(0.8),
          child: SizedBox(
            width: double.infinity,
            height: _kHeight,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => _kHeight;

  @override
  double get minExtent => _kHeight;

  @override
  bool shouldRebuild(_SearchPersistentHeader oldDelegate) =>
      child != oldDelegate.child;
}
