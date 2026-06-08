import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/gsy_card_item.dart';

/// 动态页 — 模拟 GitHub 事件流
class DynamicPage extends StatefulWidget {
  const DynamicPage({super.key});

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 模拟事件数据
  static const _events = <_EventItem>[
    _EventItem(
      type: _EventType.push,
      avatarUrl: null,
      userName: 'CarGuo',
      repoName: 'gsy_github_app_flutter',
      action: 'pushed 3 commits to master',
      time: '2 hours ago',
      detail: '523a34d 代码删减\n7ad5e13 Add Patrol regression tests',
    ),
    _EventItem(
      type: _EventType.star,
      avatarUrl: null,
      userName: 'flutterdev',
      repoName: 'flutter',
      action: 'starred flutter/flutter',
      time: '4 hours ago',
      detail: null,
    ),
    _EventItem(
      type: _EventType.create,
      avatarUrl: null,
      userName: 'octocat',
      repoName: 'hello-world',
      action: 'created repository octocat/hello-world',
      time: '6 hours ago',
      detail: 'My first repository on GitHub!',
    ),
    _EventItem(
      type: _EventType.fork,
      avatarUrl: null,
      userName: 'devuser',
      repoName: 'gsy_github_app_flutter',
      action: 'forked CarGuo/gsy_github_app_flutter',
      time: '8 hours ago',
      detail: null,
    ),
    _EventItem(
      type: _EventType.issue,
      avatarUrl: null,
      userName: 'contributor',
      repoName: 'gsy_github_app_flutter',
      action: 'opened issue #42',
      time: '12 hours ago',
      detail: 'App crashes on login page when using dark mode',
    ),
    _EventItem(
      type: _EventType.push,
      avatarUrl: null,
      userName: 'CarGuo',
      repoName: 'gsy_github_app_flutter',
      action: 'pushed 1 commit to dev',
      time: '1 day ago',
      detail: 'cbcc01b docs: add HarmonyOS and Flutter project links',
    ),
    _EventItem(
      type: _EventType.star,
      avatarUrl: null,
      userName: 'newuser',
      repoName: 'gsy_github_app_flutter',
      action: 'starred CarGuo/gsy_github_app_flutter',
      time: '1 day ago',
      detail: null,
    ),
    _EventItem(
      type: _EventType.pullRequest,
      avatarUrl: null,
      userName: 'helper',
      repoName: 'gsy_github_app_flutter',
      action: 'opened pull request #38',
      time: '2 days ago',
      detail: 'Fix: resolve network timeout on slow connections',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: GSYColors.mainBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return _EventCard(
            event: _events[index],
            index: index,
          );
        },
      ),
    );
  }
}

enum _EventType { push, star, create, fork, issue, pullRequest }

class _EventItem {
  final _EventType type;
  final String? avatarUrl;
  final String userName;
  final String repoName;
  final String action;
  final String time;
  final String? detail;

  const _EventItem({
    required this.type,
    this.avatarUrl,
    required this.userName,
    required this.repoName,
    required this.action,
    required this.time,
    this.detail,
  });
}

class _EventCard extends StatefulWidget {
  final _EventItem event;
  final int index;

  const _EventCard({required this.event, required this.index});

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  double _opacity = 0;
  double _offsetY = 20;

  @override
  void initState() {
    super.initState();
    // 首帧后触发动画，只执行一次
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1;
          _offsetY = 0;
        });
      }
    });
  }

  _EventItem get _event => widget.event;

  IconData _getEventIcon() {
    switch (_event.type) {
      case _EventType.push:
        return Icons.commit;
      case _EventType.star:
        return Icons.star_rounded;
      case _EventType.create:
        return Icons.add_circle_outline;
      case _EventType.fork:
        return Icons.call_split;
      case _EventType.issue:
        return Icons.bug_report_outlined;
      case _EventType.pullRequest:
        return Icons.merge_type;
    }
  }

  Color _getEventColor() {
    switch (_event.type) {
      case _EventType.push:
        return const Color(0xFF6f42c1);
      case _EventType.star:
        return const Color(0xFFe3b341);
      case _EventType.create:
        return const Color(0xFF28a745);
      case _EventType.fork:
        return const Color(0xFF0366d6);
      case _EventType.issue:
        return const Color(0xFFd73a49);
      case _EventType.pullRequest:
        return const Color(0xFF28a745);
    }
  }

  String _getEventTypeLabel() {
    switch (_event.type) {
      case _EventType.push:
        return 'PushEvent';
      case _EventType.star:
        return 'WatchEvent';
      case _EventType.create:
        return 'CreateEvent';
      case _EventType.fork:
        return 'ForkEvent';
      case _EventType.issue:
        return 'IssuesEvent';
      case _EventType.pullRequest:
        return 'PullRequestEvent';
    }
  }

  @override
  Widget build(BuildContext context) {
    final delayMs = 400 + widget.index * 60;
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: delayMs),
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: Offset(0, _offsetY * 0.008),
        duration: Duration(milliseconds: delayMs),
        curve: Curves.easeOutCubic,
        child: GSYCardItem(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧时间线指示器
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getEventColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getEventIcon(),
                    color: _getEventColor(),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // 右侧内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户名 + 事件类型标签
                      Row(
                        children: [
                          Text(
                            _event.userName,
                            style: GSYConstant.smallTextBold,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getEventColor().withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getEventTypeLabel(),
                              style: TextStyle(
                                fontSize: 10,
                                color: _getEventColor(),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _event.time,
                            style: GSYConstant.minText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // 仓库名
                      Row(
                        children: [
                          const Icon(Icons.book_outlined,
                              size: 14, color: GSYColors.subTextColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _event.repoName,
                              style: GSYConstant.smallSubText.copyWith(
                                color: GSYColors.actionBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // 动作描述
                      Text(
                        _event.action,
                        style: GSYConstant.smallText,
                      ),
                      // 详情（如果有）
                      if (_event.detail != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FA),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFE1E4E8),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            _event.detail!,
                            style: GSYConstant.smallText.copyWith(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: GSYColors.primaryLightValue,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
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
