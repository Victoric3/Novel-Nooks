import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreenSmall extends StatefulWidget {
  const SettingsScreenSmall({super.key});

  @override
  State<SettingsScreenSmall> createState() => _SettingsScreenSmallState();
}

class _SettingsScreenSmallState extends State<SettingsScreenSmall> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      {
        'icon': Feather.gift,
        'title': 'Earn Rewards',
        'function': () => _pushPage(const FavoritesRoute()),
      },
      {
        'icon': Feather.heart,
        'title': 'Favorites',
        'function': () => _pushPage(const FavoritesRoute()),
      },
      {
        'icon': Feather.download,
        'title': 'Downloads',
        'function': () => _pushPage(const DownloadsRoute()),
      },
      {
        'icon': Feather.moon,
        'title': 'Dark Mode',
        'function': null,
      },
      {
        'icon': Feather.info,
        'title': 'About',
        'function': () => showAbout(),
      },
      {
        'icon': Feather.file_text,
        'title': 'Open Source Licenses',
        'function': () => _pushPage(const LicensesRoute()),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: lightAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add your settings action here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: lightAccent,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pushPage(SignInRoute());
                      },
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: Color(0xFF5A4C8B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        _pushPage(SignInRoute());
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'ID: 911239',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  'coin ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '>',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 20),
                        Text(
                          '|',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  'voucher ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '>',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 56.0,
                            ),
                            child: const Text('TOP UP'),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700.withOpacity(0.6),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_right_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List of Menu Items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                if (items[index]['title'] == 'Dark Mode') {
                  if (context.isPlatformDarkThemed) {
                    return const SizedBox.shrink();
                  }
                  return _ThemeSwitch(
                    icon: items[index]['icon'] as IconData,
                    title: items[index]['title'] as String,
                  );
                }

                return ListTile(
                  onTap: items[index]['function'] as Function(),
                  leading: Icon(
                    items[index]['icon'] as IconData,
                    color: lightAccent,
                  ),
                  title: Text(items[index]['title'] as String),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                if (items[index]['title'] == 'Dark Mode' &&
                    context.isPlatformDarkThemed) {
                  return const SizedBox.shrink();
                }
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pushPage(PageRouteInfo route) {
    if (context.isLargeScreen) {
      context.router.replace(route);
    } else {
      context.router.push(route);
    }
  }

  Future<void> showAbout() async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text(
            'Novel Nooks is an ebook app by Chukwujiobi Victor Ifeanyi using Flutter Sdk',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeSwitch extends ConsumerWidget {
  final IconData icon;
  final String title;

  const _ThemeSwitch({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAppTheme = ref.watch(currentAppThemeNotifierProvider);
    return SwitchListTile(
      secondary: Icon(icon, color: lightAccent),
      title: Text(title),
      value: currentAppTheme.value == CurrentAppTheme.dark,
      onChanged: (isDarkMode) {
        ref
            .read(currentAppThemeNotifierProvider.notifier)
            .updateCurrentAppTheme(isDarkMode);
      },
    );
  }
}
