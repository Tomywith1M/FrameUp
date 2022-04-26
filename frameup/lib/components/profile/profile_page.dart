import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frameup/app/theme.dart';
import 'package:frameup/components/Publish/publish.dart';
import 'package:frameup/components/Widg/Characters.dart';
import 'package:frameup/navigation/custom_rect_tween.dart';
import 'package:frameup/navigation/hero_dialog_route.dart';
import 'package:frameup/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:frameup/components/profile/Profile_editor.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatFeedCore(
      feedGroup: 'user',
      loadingBuilder: (context) =>
          const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, error) => const Center(
        child: Text('Error loading profile'),
      ),
      emptyBuilder: (context) => const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(
              numberOfPosts: 0,
            ),
          ),
          SliverToBoxAdapter(
            child: _ProfileSwitch(),
          ),
          SliverFillRemaining(child: _NoPostsMessage())
        ],
      ),
      feedBuilder: (context, activities) {
        return RefreshIndicator(
          onRefresh: () async {
            await FeedProvider.of(context)
                .bloc
                .currentUser!
                .get(withFollowCounts: true);
            return FeedProvider.of(context)
                .bloc
                .queryEnrichedActivities(feedGroup: 'user');
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ProfileHeader(
                  numberOfPosts: activities.length,
                ),
              ),
              const SliverToBoxAdapter(
                child: _ProfileSwitch(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activity = activities[index];
                    final url =
                        activity.extraData!['resized_image_url'] as String;
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          HeroDialogRoute(
                            builder: (context) {
                              return _PictureViewer(activity: activity);
                            },
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'hero-image-${activity.id}',
                        child: CachedNetworkImage(
                          key: ValueKey('image-${activity.id}'),
                          width: 199,
                          height: 199,
                          fit: BoxFit.cover,
                          imageUrl: url,
                        ),
                      ),
                    );
                  },
                  childCount: activities.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ProfileSwitch extends StatelessWidget {
  const _ProfileSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).push(ProfileEditorScreen.route);
        },
        child: const Text('Edit Profile'),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    Key? key,
    required this.numberOfPosts,
  }) : super(key: key);

  final int numberOfPosts;

  static const _statitisticsPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 6.0);

  @override
  Widget build(BuildContext context) {
    final feedState = context.watch<AppState>();
    final frameUser = feedState.frameUser;
    if (frameUser == null) return const SizedBox.shrink();
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Character.big(
                frameUser: frameUser,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: _statitisticsPadding,
                  child: Column(
                    children: [
                      Text(
                        '$numberOfPosts',
                        style: AppTextStyle.textStyleBold,
                      ),
                      const Text(
                        'Posts',
                        style: AppTextStyle.textStyleLight,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: _statitisticsPadding,
                  child: Column(
                    children: [
                      Text(
                        '${FeedProvider.of(context).bloc.currentUser?.followersCount ?? 0}',
                        style: AppTextStyle.textStyleBold,
                      ),
                      const Text(
                        'Followers',
                        style: AppTextStyle.textStyleLight,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: _statitisticsPadding,
                  child: Column(
                    children: [
                      Text(
                        '${FeedProvider.of(context).bloc.currentUser?.followingCount ?? 0}',
                        style: AppTextStyle.textStyleBold,
                      ),
                      const Text(
                        'Following',
                        style: AppTextStyle.textStyleLight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(frameUser.fullName,
                style: AppTextStyle.textStyleBoldMedium),
          ),
        ),
      ],
    );
  }
}

class _NoPostsMessage extends StatelessWidget {
  const _NoPostsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Not Enough!'),
        const SizedBox(height: 13),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(PublishScreen.route); // ADD THIS
          },
          child: const Text('Add a post'),
        )
      ],
    );
  }
}

class _PictureViewer extends StatelessWidget {
  const _PictureViewer({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  Widget build(BuildContext context) {
    final resizedUrl = activity.extraData!['resized_image_url'] as String?;
    final fullSizeUrl = activity.extraData!['image_url'] as String;
    final aspectRatio = activity.extraData!['aspect_ratio'] as double?;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: 'hero-image-${activity.id}',
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin, end: end);
            },
            child: AspectRatio(
              aspectRatio: aspectRatio ?? 1,
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero,
                placeholder: (resizedUrl != null)
                    ? (context, url) => CachedNetworkImage(
                          imageBuilder: (context, imageProvider) =>
                              DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          imageUrl: resizedUrl,
                        )
                    : null,
                imageBuilder: (context, imageProvider) => DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                imageUrl: fullSizeUrl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
