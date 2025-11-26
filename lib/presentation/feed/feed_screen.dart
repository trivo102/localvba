import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:vba/core/commom/helpers/date_extensions.dart';
import 'package:vba/data/models/post/post.dart';
import 'package:vba/presentation/feed/bloc/feed_bloc.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc()..add(const FeedLoadRequested()),
      child: const FeedView(),
    );
  }
}

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FeedBloc>().add(FeedLoadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
        switch (state.status) {
          case FeedStatus.initial:
          case FeedStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case FeedStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Failed to load feed',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FeedBloc>().add(
                            const FeedLoadRequested(isRefresh: true),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          case FeedStatus.success:
          case FeedStatus.loadingMore:
            if (state.posts.isEmpty) {
              return const Center(
                child: Text('No posts available'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FeedBloc>().add(
                      const FeedLoadRequested(isRefresh: true),
                    );
              },
              child: ListView.builder(
                controller: _scrollController,
                // +1 for "Create Post" card
                itemCount: state.posts.length +
                    1 +
                    (state.status == FeedStatus.loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // First widget is always "Create Post" card
                  if (index == 0) {
                    return const CreatePostCard();
                  }

                  // Loading indicator at the end
                  if (index == state.posts.length + 1) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Subtract 1 to get correct post index
                  final post = state.posts[index - 1];
                  return PostCard(post: post);
                },
              ),
            );
        }
      }),
    );
  }
}

class CreatePostCard extends StatelessWidget {
  const CreatePostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const CircleAvatar(
              // Lấy avatar của user đang đăng nhập
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            // Dùng Expanded để Text chiếm hết phần còn lại
            Expanded(
              child: Text(
                'Bạn đang nghĩ gì?',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            // Nút đăng ảnh
            IconButton(
              icon: Icon(Icons.image, color: Colors.green[400]),
              onPressed: () {
                // Xử lý logic đăng bài (chuyển trang)
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header của Post (Avatar, Tên, Thời gian)
          _buildPostHeader(),

          // 2. Nội dung text của Post
          if (widget.post.content != null && widget.post.content!.isNotEmpty)
            _buildExpandableContent(),

          // 4. Dải phân cách
          const Divider(height: 1),

          // 5. Footer (Like, Comment)
          _buildPostFooter(),
        ],
      ),
    );
  }

  Widget _buildExpandableContent() {
    final content = widget.post.content ?? '';
    // Estimate if content is long (simple check by character count)
    final isLongContent = content.length > 300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCrossFade(
                firstChild: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 150), // Limit height for ~5 lines
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: HtmlWidget(
                      content,
                      textStyle: const TextStyle(fontSize: 14),
                      renderMode: RenderMode.column,
                      onTapUrl: (url) {
                        return true;
                      },
                    ),
                  ),
                ),
                secondChild: HtmlWidget(
                  content,
                  textStyle: const TextStyle(fontSize: 14),
                  renderMode: RenderMode.column,
                  onTapUrl: (url) {
                    return true;
                  },
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
              if (isLongContent)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      _isExpanded ? 'Ẩn bớt' : 'Xem thêm',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Hiển thị hình ảnh
        if (widget.post.images != null && widget.post.images!.isNotEmpty)
          _buildImages(),
      ],
    );
  }

  Widget _buildImages() {
    final images = widget.post.images!;

    if (images.length == 1) {
      // Single image - full width
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            images[0].url ?? '',
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 50),
                ),
              );
            },
          ),
        ),
      );
    } else if (images.length == 2) {
      // Two images - side by side
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: images.map((image) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    image.url ?? '',
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (images.length == 3) {
      // Three images - one big, two small
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  images[0].url ?? '',
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[1].url ?? '',
                      height: 148,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 148,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 30),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[2].url ?? '',
                      height: 148,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 148,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 30),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Four or more images - 2x2 grid with "+X more" overlay
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[0].url ?? '',
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[1].url ?? '',
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[2].url ?? '',
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.network(
                          images[3].url ?? '',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        if (images.length > 4)
                          Container(
                            color: Colors.black.withAlpha(100),
                            child: Center(
                              child: Text(
                                '+${images.length - 4}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPostHeader() {
    // Format timestamp
    String formattedTime = 'Just now';
    if (widget.post.createdAt != null) {
      try {
        final dateTime = DateTime.parse(widget.post.createdAt!);
        formattedTime = dateTime.timeAgo();
      } catch (e) {
        formattedTime = widget.post.createdAt ?? 'Just now';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.post.owner?.avatar != null
                ? NetworkImage(widget.post.owner!.avatar!)
                : null,
            child: widget.post.owner?.avatar == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.owner?.fullName ?? 'Unknown User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Xử lý menu (VD: Báo cáo, Xóa bài)
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPostFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFooterButton(
            icon: widget.post.isLiked == true
                ? Icons.thumb_up
                : Icons.thumb_up_outlined,
            label:
                'Thích${widget.post.likeCount != null && widget.post.likeCount! > 0 ? ' (${widget.post.likeCount})' : ''}',
            onPressed: () {},
            color: widget.post.isLiked == true ? Colors.blue : null,
          ),
          _buildFooterButton(
            icon: Icons.comment_outlined,
            label:
                'Bình luận${widget.post.commentCount != null && widget.post.commentCount! > 0 ? ' (${widget.post.commentCount})' : ''}',
            onPressed: () {},
          ),
          _buildFooterButton(
            icon: Icons.share_outlined,
            label: 'Chia sẻ',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color ?? Colors.grey[700], size: 20),
      label: Text(
        label,
        style: TextStyle(color: color ?? Colors.grey[700]),
      ),
    );
  }
}
