import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/widget/gsy_card_item.dart';

/// 趋势页 — 模拟 GitHub Trending
class TrendPage extends StatefulWidget {
  const TrendPage({super.key});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _selectedPeriod = 0;
  static const _periods = ['Today', 'This Week', 'This Month'];

  // 模拟趋势仓库数据
  static const _repos = <_TrendRepo>[
    _TrendRepo(
      name: 'flutter/flutter',
      desc: 'Flutter makes it easy and fast to build beautiful apps for mobile and beyond.',
      language: 'Dart',
      languageColor: Color(0xFF00B4AB),
      stars: 168200,
      forks: 27800,
      todayStars: 342,
      periodStars: '+2.1k this week',
    ),
    _TrendRepo(
      name: 'CarGuo/gsy_github_app_flutter',
      desc: 'Flutter 超完整的开源项目，功能丰富，适合学习和日常使用。',
      language: 'Dart',
      languageColor: Color(0xFF00B4AB),
      stars: 19800,
      forks: 3400,
      todayStars: 89,
      periodStars: '+420 this week',
    ),
    _TrendRepo(
      name: 'facebook/react',
      desc: 'The library for web and native user interfaces.',
      language: 'JavaScript',
      languageColor: Color(0xFFF1E05A),
      stars: 231000,
      forks: 47200,
      todayStars: 156,
      periodStars: '+1.2k this week',
    ),
    _TrendRepo(
      name: 'denoland/deno',
      desc: 'A modern runtime for JavaScript and TypeScript.',
      language: 'Rust',
      languageColor: Color(0xFFDEA584),
      stars: 98500,
      forks: 5400,
      todayStars: 78,
      periodStars: '+560 this week',
    ),
    _TrendRepo(
      name: 'vercel/next.js',
      desc: 'The React Framework for the Web. Used by some of the world\'s largest companies.',
      language: 'JavaScript',
      languageColor: Color(0xFFF1E05A),
      stars: 128000,
      forks: 27400,
      todayStars: 120,
      periodStars: '+890 this week',
    ),
    _TrendRepo(
      name: 'rust-lang/rust',
      desc: 'Empowering everyone to build reliable and efficient software.',
      language: 'Rust',
      languageColor: Color(0xFFDEA584),
      stars: 99200,
      forks: 12800,
      todayStars: 95,
      periodStars: '+670 this week',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: GSYColors.mainBackgroundColor,
      child: Column(
        children: [
          // 时间段选择器
          _buildPeriodSelector(),
          // 仓库列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _repos.length,
              itemBuilder: (context, index) {
                return _TrendRepoCard(
                  repo: _repos[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(4),
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
      child: Row(
        children: List.generate(_periods.length, (index) {
          final selected = _selectedPeriod == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? GSYColors.primaryValue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _periods[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? Colors.white : GSYColors.subTextColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TrendRepo {
  final String name;
  final String desc;
  final String language;
  final Color languageColor;
  final int stars;
  final int forks;
  final int todayStars;
  final String periodStars;

  const _TrendRepo({
    required this.name,
    required this.desc,
    required this.language,
    required this.languageColor,
    required this.stars,
    required this.forks,
    required this.todayStars,
    required this.periodStars,
  });

  String get starsText {
    if (stars >= 1000) return '${(stars / 1000).toStringAsFixed(1)}k';
    return stars.toString();
  }

  String get forksText {
    if (forks >= 1000) return '${(forks / 1000).toStringAsFixed(1)}k';
    return forks.toString();
  }
}

class _TrendRepoCard extends StatefulWidget {
  final _TrendRepo repo;
  final int index;

  const _TrendRepoCard({required this.repo, required this.index});

  @override
  State<_TrendRepoCard> createState() => _TrendRepoCardState();
}

class _TrendRepoCardState extends State<_TrendRepoCard> {
  double _opacity = 0;
  double _offsetX = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1;
          _offsetX = 0;
        });
      }
    });
  }

  _TrendRepo get _repo => widget.repo;

  @override
  Widget build(BuildContext context) {
    final delayMs = 350 + widget.index * 50;
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: delayMs),
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: Offset(_offsetX * 0.15, 0),
        duration: Duration(milliseconds: delayMs),
        curve: Curves.easeOutCubic,
        child: GSYCardItem(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 仓库全名 + stars 标签
                Row(
                  children: [
                    const Icon(Icons.book_outlined,
                        size: 16, color: Color(0xFF0366d6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _repo.name,
                        style: GSYConstant.smallTextBold.copyWith(
                          color: const Color(0xFF0366d6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Today stars 标签
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF28a745).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up,
                              size: 12, color: Color(0xFF28a745)),
                          const SizedBox(width: 3),
                          Text(
                            '+${_repo.todayStars}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF28a745),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 描述
                Text(
                  _repo.desc,
                  style: GSYConstant.smallSubText.copyWith(height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // 底部统计行
                Row(
                  children: [
                    // 语言圆点 + 名称
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _repo.languageColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(_repo.language, style: GSYConstant.minText),
                    const SizedBox(width: 16),
                    // Stars
                    const Icon(Icons.star_outline,
                        size: 14, color: Color(0xFFe3b341)),
                    const SizedBox(width: 3),
                    Text(_repo.starsText,
                        style: GSYConstant.minText.copyWith(
                            fontFamily: 'monospace',
                            color: GSYColors.mainTextColor)),
                    const SizedBox(width: 16),
                    // Forks
                    const Icon(Icons.call_split,
                        size: 14, color: GSYColors.subTextColor),
                    const SizedBox(width: 3),
                    Text(_repo.forksText,
                        style: GSYConstant.minText.copyWith(
                            fontFamily: 'monospace',
                            color: GSYColors.mainTextColor)),
                    const Spacer(),
                    // 周期增长
                    Text(
                      _repo.periodStars,
                      style: GSYConstant.minText.copyWith(
                        color: const Color(0xFF28a745),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
