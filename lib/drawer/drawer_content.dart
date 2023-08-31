import 'package:flutter/material.dart';
import 'package:flutter_crawl/models/route.dart';
import 'package:go_router/go_router.dart';

class RootDrawerContent extends StatelessWidget {
  RootDrawerContent({super.key});

  final routes = [
    RouteModel(
      navigation: NavigateStatus.go,
      name: "Home",
      path: "/",
      icon: Icons.home,
    ),
    RouteModel(
      navigation: NavigateStatus.push,
      name: "Settings",
      path: "/setting",
      icon: Icons.settings,
    ),
    RouteModel(
      navigation: NavigateStatus.push,
      name: "Sign in",
      path: "/auth",
      icon: Icons.supervised_user_circle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute = "/${ModalRoute.of(context)?.settings.name}";

    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          height: 0,
          thickness: 3,
        ),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final item = routes[index];
          return InkWell(
            onTap: () {
              String path = currentRoute;

              if (path == "//") {
                path = "/";
              }

              if (path == item.path) return;

              switch (item.navigation) {
                case NavigateStatus.push:
                  context.push(item.path);
                  break;
                case NavigateStatus.pushReplacement:
                  context.pushReplacement(item.path);
                  break;
                case NavigateStatus.go:
                default:
                  context.go(item.path);
                  break;
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
