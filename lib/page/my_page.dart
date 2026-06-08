import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:redux/redux.dart';

/// 主页我的tab页 — 个人资料仪表盘
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  Store<GSYState>? _getStore() {
    return StoreProvider.of(context);
  }

  @override
  bool get wantKeepAlive => true;

  // 模拟统计数据
  static const _stats = [
    _StatItem('Repositories', '42', Icons.folder_outlined, Color(0xFF0366d6)),
    _StatItem('Stars', '1.2k', Icons.star_outline, Color(0xFFe3b341)),
    _StatItem('Followers', '368', Icons.people_outline, Color(0xFF28a745)),
    _StatItem('Following', '127', Icons.person_add_outlined, Color(0xFF6f42c1)),
  ];

  static const _menuItems = [
    _MenuItem('Profile', Icons.person_outline, Color(0xFF0366d6)),
    _MenuItem('Repositories', Icons.folder_outlined, Color(0xFF28a745)),
    _MenuItem('Starred', Icons.star_border, Color(0xFFe3b341)),
    _MenuItem('Organizations', Icons.business_outlined, Color(0xFF6f42c1)),
    _MenuItem('Settings', Icons.settings_outlined, Color(0xFF57606a)),
    _MenuItem('Theme', Icons.palette_outlined, Color(0xFFd73a49)),
    _MenuItem('Language', Icons.language, Color(0xFF0366d6)),
    _MenuItem('About', Icons.info_outline, Color(0xFF57606a)),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        final userInfo = store.state.userInfo;
        final isLoggedIn = store.state.login == true;
        final displayName =
            userInfo?.name ?? userInfo?.username ?? 'GSYGithubApp';
        final displayEmail = userInfo?.email ?? 'demo@example.com';

        return Container(
          color: GSYColors.mainBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 头部资料卡
              _buildProfileHeader(displayName, displayEmail, isLoggedIn),
              const SizedBox(height: 8),
              // 统计网格
              _buildStatsGrid(),
              const SizedBox(height: 8),
              // Pinned Repos 区域
              _buildPinnedRepos(),
              const SizedBox(height: 8),
              // 菜单列表
              _buildMenuSection(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(String name, String email, bool isLoggedIn) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            GSYColors.primaryValue,
            GSYColors.primaryLightValue,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            children: [
              // 头像 + 在线状态
              Stack(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage(GSYICons.DEFAULT_USER_ICON),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isLoggedIn
                            ? const Color(0xFF28a745)
                            : GSYColors.subTextColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // 用户名
              Text(
                name,
                style: GSYConstant.largeTextWhiteBold.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 4),
              // 邮箱
              Text(
                '@${email.split('@').first}',
                style: GSYConstant.smallTextWhite.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              // Bio 标签行
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChip(Icons.code, 'Flutter'),
                  const SizedBox(width: 8),
                  _buildChip(Icons.location_on_outlined, 'China'),
                  const SizedBox(width: 8),
                  _buildChip(Icons.calendar_today_outlined, 'Joined 2020'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: _stats.map((stat) {
          final index = _stats.indexOf(stat);
          return Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + index * 80),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == _stats.length - 1 ? 0 : 4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(stat.icon, color: stat.color, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      stat.value,
                      style: GSYConstant.middleTextBold.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stat.label,
                      style: GSYConstant.minText.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPinnedRepos() {
    final pinnedRepos = [
      _PinnedRepo('gsy_github_app_flutter', 'Flutter 完整开源项目',
          'Dart', const Color(0xFF00B4AB), 19800),
      _PinnedRepo('gsy_github_app', 'Android 开源项目',
          'Java', const Color(0xFFb07219), 7200),
      _PinnedRepo('gsy_github_app_kotlin', 'Kotlin 开源项目',
          'Kotlin', const Color(0xFFA97BFF), 3100),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF28a745),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Pinned Repositories',
                    style: GSYConstant.middleTextBold),
              ],
            ),
          ),
          ...pinnedRepos.map((repo) => _buildPinnedRepoCard(repo)),
        ],
      ),
    );
  }

  Widget _buildPinnedRepoCard(_PinnedRepo repo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.book_outlined, size: 16, color: Color(0xFF0366d6)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  repo.name,
                  style: GSYConstant.smallTextBold.copyWith(
                    color: const Color(0xFF0366d6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(repo.desc, style: GSYConstant.smallSubText),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: repo.langColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(repo.lang, style: GSYConstant.minText),
              const SizedBox(width: 14),
              const Icon(Icons.star_outline,
                  size: 13, color: Color(0xFFe3b341)),
              const SizedBox(width: 3),
              Text(
                repo.stars >= 1000
                    ? '${(repo.stars / 1000).toStringAsFixed(1)}k'
                    : repo.stars.toString(),
                style: GSYConstant.minText.copyWith(
                  fontFamily: 'monospace',
                  color: GSYColors.mainTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: List.generate(_menuItems.length, (index) {
            final item = _menuItems[index];
            final isLast = index == _menuItems.length - 1;
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.icon, color: item.color, size: 18),
                  ),
                  title: Text(
                    item.title,
                    style: GSYConstant.smallText.copyWith(fontSize: 15),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: GSYColors.subLightTextColor,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  dense: true,
                  onTap: () {},
                ),
                if (!isLast)
                  Divider(
                    height: 0.5,
                    indent: 62,
                    endIndent: 14,
                    color: GSYColors.subLightTextColor.withValues(alpha: 0.3),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem(this.label, this.value, this.icon, this.color);
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;

  const _MenuItem(this.title, this.icon, this.color);
}

class _PinnedRepo {
  final String name;
  final String desc;
  final String lang;
  final Color langColor;
  final int stars;

  const _PinnedRepo(this.name, this.desc, this.lang, this.langColor, this.stars);
}
