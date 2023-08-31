import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/blocs/auth/auth_bloc.dart';
import 'package:flutter_crawl/cubits/theme/theme_cubit.dart';
import 'package:flutter_crawl/drawer/drawer_content.dart';
import 'package:flutter_crawl/drawer/drawer_footer.dart';
import 'package:flutter_crawl/drawer/drawer_header.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/user/user.dart';

class RootDrawerInherited extends InheritedWidget {
  final UserModel user;
  final AuthStatus authStatus;

  const RootDrawerInherited({
    super.key,
    required this.user,
    required this.authStatus,
    required super.child,
  });

  static RootDrawerInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RootDrawerInherited>();
  }

  @override
  bool updateShouldNotify(RootDrawerInherited oldWidget) {
    return authStatus != oldWidget.authStatus;
  }
}

class RootDrawer extends StatelessWidget {
  const RootDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        state.user;
        return RootDrawerInherited(
          user: state.status == AuthStatus.authenticated
              ? state.user
              : UserModel.empty,
          authStatus: state.status,
          child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 1,
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Container(
                  color: state.useTheme.scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      const RootDrawerHeader(),
                      const Divider(
                        height: 0,
                        thickness: 3,
                      ),
                      RootDrawerContent(),
                      const Divider(
                        height: 0,
                        thickness: 3,
                      ),
                      const RootDrawerFooter(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
