import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/presentation/feed/feed_screen.dart' show PostCard;
import 'package:vba/presentation/group_detail/group_feed_tab/bloc/group_feed_bloc.dart';
import 'package:vba/presentation/group_detail/group_detail_screen.dart' show GroupDetailPage;

class GroupFeedTab extends StatefulWidget {
  const GroupFeedTab({Key? key}) : super(key: key);

  @override
  State<GroupFeedTab> createState() => _GroupFeedTabState();
}

class _GroupFeedTabState extends State<GroupFeedTab> {
  final ScrollController _scrollController = ScrollController();

  String get _groupId {
    // Read from inherited GroupDetailPage via context.widget if available
    final widgetOwner = context.findAncestorWidgetOfExactType<GroupDetailPage>();
    if (widgetOwner != null) {
      return widgetOwner.group.id ?? '';
    }
    // Fallback: ModalRoute arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['groupId'] is String) {
      return args['groupId'] as String;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (offset >= max * 0.9) {
      context.read<GroupFeedBloc>().add(GroupFeedLoadMoreRequested(_groupId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupFeedBloc()..add(GroupFeedLoadRequested(_groupId)),
      child: BlocBuilder<GroupFeedBloc, GroupFeedState>(
        builder: (context, state) {
          switch (state.status) {
            case GroupFeedStatus.initial:
            case GroupFeedStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case GroupFeedStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? 'Tải bài viết thất bại', style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<GroupFeedBloc>().add(GroupFeedRefreshRequested(_groupId)),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            case GroupFeedStatus.success:
            case GroupFeedStatus.loadingMore:
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GroupFeedBloc>().add(GroupFeedRefreshRequested(_groupId));
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.posts.length + (state.status == GroupFeedStatus.loadingMore ? 1 : 0),
                  itemBuilder: (ctx, idx) {
                    if (idx == state.posts.length && state.status == GroupFeedStatus.loadingMore) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final post = state.posts[idx];
                    return PostCard(post: post);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
