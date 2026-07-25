import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:github/github.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_model.dart';
import '../../app_config.dart';
import '../../common/view/progress.dart';
import '../../common/view/tapable_text.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/build_context_x.dart';
import '../../l10n/l10n.dart';

const _kTileSize = 60.0;

/// 贡献者对话框：从 GitHub 拉取 flstash 仓库的贡献者列表并展示头像网格。
class ContributorsDialog extends StatelessWidget {
  const ContributorsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(context.l10n.contributors),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: const SizedBox(
        height: 600,
        width: 500,
        child: _ContributorsPage(),
      ),
    );
  }
}

class _ContributorsPage extends StatefulWidget {
  const _ContributorsPage();

  @override
  State<_ContributorsPage> createState() => _ContributorsPageState();
}

class _ContributorsPageState extends State<_ContributorsPage> {
  late Future<List<Contributor>> _contributors;

  @override
  void initState() {
    super.initState();
    _contributors = di<AppModel>().getContributors();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final linkStyle = theme.textTheme.bodyLarge?.copyWith(
      color: Colors.lightBlue,
      overflow: TextOverflow.visible,
    );

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Contributor>>(
            future: _contributors,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(context.l10n.copyrightNotice));
              }
              if (snapshot.hasData) {
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSmallestSpace,
                    vertical: kSmallestSpace,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: _kTileSize,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final e = snapshot.data!.elementAt(index);
                    return Tooltip(
                      message: e.login,
                      child: Card(
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: e.htmlUrl == null
                              ? null
                              : () => launchUrl(Uri.parse(e.htmlUrl!)),
                          child: e.avatarUrl == null
                              ? const Icon(Icons.person)
                              : Image.network(
                                  e.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.person),
                                ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: Progress());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: kLargestSpace,
            right: kLargestSpace,
            top: kMediumSpace,
            bottom: kMediumSpace,
          ),
          child: TapAbleText(
            style: linkStyle,
            onTap: () => launchUrl(Uri.parse(AppConfig.repoUrl)),
            text: context.l10n.copyrightNotice,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
