import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/common/utils/contentSearch.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ebook_app/src/features/auth/blocs/auth_helpers.dart';
import 'package:flutter_ebook_app/src/common/constants/global_state.dart';

class HomeScreenSmall extends ConsumerStatefulWidget {
  const HomeScreenSmall({super.key});

  @override
  ConsumerState<HomeScreenSmall> createState() => _HomeScreenSmallState();
}

class _HomeScreenSmallState extends ConsumerState<HomeScreenSmall> {
  void loadData() {
    ref.read(homeFeedNotifierProvider.notifier).fetch();
  }

  Future<void> retryAuthentication() async {
    print("retring..");
    final authStatus = await checkTokenInCookie(ref);
    if (authStatus == AuthStatus.notAuthenticated) {
      // Navigate to login if not authenticated
      context.router.replace(SignInRoute());
    } else if (authStatus == AuthStatus.authenticated) {
      // Re-fetch home data if re-authenticated
      ref.read(homeFeedNotifierProvider).maybeWhen(
            orElse: () => loadData(),
            data: (_) => null,
          );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check authentication state after first frame
      final authStatus = await checkTokenInCookie(ref);
      if (authStatus == AuthStatus.notAuthenticated) {
        // Navigate to login if not authenticated
        context.router.replace(SignInRoute());
      } else {
        ref.read(homeFeedNotifierProvider).maybeWhen(
              orElse: () => loadData(),
              data: (_) => null,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeDataState = ref.watch(homeFeedNotifierProvider);
    final userData = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: context.isSmallScreen
          ? AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
              automaticallyImplyLeading: false,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/app-icon.png',
                              fit: BoxFit.contain,
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            appName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showSearch(
                                  context: context, delegate: ContentSearch());
                            },
                            child: Icon(Icons.search,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.notifications_off_sharp,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8.0),
                          CircleAvatar(
                            radius: 18.0,
                            backgroundColor: lightAccent,
                            backgroundImage: userData!["photo"] != null &&
                                    userData["photo"].isNotEmpty
                                ? NetworkImage(userData["photo"])
                                : null,
                            child: userData["photo"] == null ||
                                    userData["photo"].isEmpty
                                ? Text(
                                    userData["firstname"] ?? 'U',
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: homeDataState.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const LoadingWidget(),
          data: (feeds) {
            final popular = feeds.popularFeed;
            final recent = feeds.recentFeed;
            return RefreshIndicator(
              onRefresh: () async => loadData(),
              child: ListView(
                children: <Widget>[
                  if (!context.isSmallScreen) const SizedBox(height: 30.0),
                  const SizedBox(height: 5.0),
                  _GenreSection(popular: popular),
                  const SizedBox(height: 20.0),
                  const _SectionTitle(title: 'Featured'),
                  FeaturedSection(popular: popular),
                  const SizedBox(height: 20.0),
                  const _SectionTitle(title: 'Recently Added'),
                  const SizedBox(height: 20.0),
                  _NewSection(recent: recent),
                ],
              ),
            );
          },
          error: (_, __) {
            return MyErrorWidget(
              refreshCallBack: () => retryAuthentication(),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedSection extends StatelessWidget {
  final CategoryFeed popular;

  const FeaturedSection({super.key, required this.popular});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: popular.feed?.entry?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Entry entry = popular.feed!.entry![index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: BookCard(
                img: entry.link![1].href!,
                entry: entry,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GenreSection extends StatelessWidget {
  final CategoryFeed popular;

  const _GenreSection({required this.popular});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: popular.feed?.link?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Link link = popular.feed!.link![index];

            // We don't need the tags from 0-9 because
            // they are not categories
            if (index < 10) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  onTap: () {
                    final route = GenreRoute(
                      title: '${link.title}',
                      url: link.href!,
                    );
                    if (context.isLargeScreen) {
                      context.router.replace(route);
                    } else {
                      context.router.push(route);
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${link.title}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NewSection extends StatelessWidget {
  final CategoryFeed recent;

  const _NewSection({required this.recent});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final Entry entry = recent.feed!.entry![index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: BookListItem(entry: entry),
        );
      },
    );
  }
}
