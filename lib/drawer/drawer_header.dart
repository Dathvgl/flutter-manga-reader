import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crawl/cubits/cultivation/cultivation_cubit.dart';
import 'package:flutter_crawl/cubits/userCultivation/user_cultivation_cubit.dart';
import 'package:flutter_crawl/drawer/drawer.dart';
import 'package:flutter_crawl/enum.dart';
import 'package:flutter_crawl/models/user/user.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RootDrawerHeader extends StatelessWidget {
  const RootDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final inherited = RootDrawerInherited.of(context) ??
        const RootDrawerInherited(
          user: UserModel.empty,
          authStatus: AuthStatus.unauthenticated,
          child: SizedBox(),
        );

    if (inherited.authStatus == AuthStatus.unauthenticated) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: AppBar().preferredSize.height,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Fsfssfssfsfsfs",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      foregroundImage: inherited.user.photo == null
                          ? null
                          : CachedNetworkImageProvider(inherited.user.photo!),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inherited.user.name ?? "empty",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BlocBuilder<UserCultivationCubit, UserCultivationState>(
                          builder: (context, state) {
                            return Text(
                              state.cultivation.xungHo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<CultivationCubit, CultivationState>(
              builder: (context, cultivationState) {
                final canhGioi = cultivationState.tuLuyen.canhGioi;
                return BlocBuilder<UserCultivationCubit, UserCultivationState>(
                  builder: (context, userState) {
                    double percent = 0;

                    final current =
                        canhGioi.get(userState.cultivation.idCanhGioi);
                    final next = canhGioi.get(current?.nextId);

                    if (current != null && next != null) {
                      final need = userState.cultivation.tuVi - current.tuVi;
                      final total = next.tuVi - current.tuVi;
                      percent = need / total;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: LinearPercentIndicator(
                        percent: percent <= 1 ? percent : 0,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
