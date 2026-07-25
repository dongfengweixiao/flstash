import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../common/view/progress.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';

/// 许可证对话框：左侧包名列表 + 右侧许可证内容（Material 主从布局）。
class LicensesDialog extends StatefulWidget with WatchItStatefulWidgetMixin {
  const LicensesDialog({super.key});

  @override
  State<LicensesDialog> createState() => _LicensesDialogState();
}

class _LicensesDialogState extends State<LicensesDialog> {
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    di<LicenseStore>().load(LicenseRegistry.licenses);
  }

  @override
  Widget build(BuildContext context) {
    final packages = watchPropertyValue((LicenseStore s) => s.packages);
    final store = di<LicenseStore>();
    return Dialog(
      child: SizedBox(
        height: 700,
        width: 900,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 260,
                  child: Column(
                    children: [
                      _DialogHeader(
                        title: context.l10n.dependencies,
                        onClose: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: packages.length,
                          itemBuilder: (context, index) => ListTile(
                            selected: index == _selected,
                            title: Text(packages[index]),
                            onTap: () => setState(() => _selected = index),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: packages.isEmpty
                      ? const Center(child: Progress())
                      : LicenseView(
                          licenses: store.licenses(packages[_selected]),
                          packageName: packages[_selected],
                          onClose: () => Navigator.of(context).pop(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LicenseStore extends SafeChangeNotifier {
  final _licenses = <String, List<LicenseEntry>>{};

  List<String> get packages => _licenses.keys.toList();
  List<LicenseEntry> licenses(String package) => _licenses[package]!;

  Future<void> load(Stream<LicenseEntry> licenses) async {
    _licenses.clear();
    await for (final license in licenses) {
      final package = license.packages.first;
      _licenses.putIfAbsent(package, () => []).add(license);
    }
    notifyListeners();
  }
}

class LicenseView extends StatefulWidget {
  const LicenseView({
    super.key,
    required this.licenses,
    required this.packageName,
    this.onClose,
  });

  final List<LicenseEntry> licenses;
  final String packageName;
  final VoidCallback? onClose;

  @override
  State<LicenseView> createState() => _LicenseViewState();
}

class _LicenseViewState extends State<LicenseView> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.onClose == null
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
        title: Text(widget.packageName),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.licenses.length,
        itemBuilder: (context, index) =>
            LicenseText(license: widget.licenses[index]),
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: widget.licenses.length > 1
          ? NaviBar(controller: _controller, length: widget.licenses.length)
          : null,
    );
  }
}

class LicenseText extends StatelessWidget {
  const LicenseText({super.key, required this.license});

  final LicenseEntry license;

  @override
  Widget build(BuildContext context) {
    final paragraphs = license.paragraphs.toList();
    const padding = EdgeInsetsDirectional.all(kLargestSpace);
    return ListView.builder(
      padding: padding,
      itemCount: paragraphs.length,
      itemBuilder: (context, index) {
        final paragraph = paragraphs[index];
        final indent = paragraph.indent * 16.0;
        return Padding(
          padding: padding + EdgeInsetsDirectional.only(start: indent),
          child: Text(
            paragraph.text,
            textAlign: paragraph.indent == LicenseParagraph.centeredIndent
                ? TextAlign.center
                : TextAlign.left,
          ),
        );
      },
    );
  }
}

class NaviBar extends StatelessWidget {
  const NaviBar({super.key, required this.length, required this.controller});

  final int length;
  final PageController controller;

  int get _currentPage => controller.page?.round() ?? 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Row(
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () => controller.previousPage(
                      duration: kSlideDuration,
                      curve: kSlideCurve,
                    )
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Center(child: Text('${_currentPage + 1} / $length')),
          ),
          IconButton(
            onPressed: _currentPage < length - 1
                ? () => controller.nextPage(
                      duration: kSlideDuration,
                      curve: kSlideCurve,
                    )
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.title, this.onClose});

  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20,
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}

const kSlideCurve = Curves.easeInOut;
const kSlideDuration = Duration(milliseconds: 200);
