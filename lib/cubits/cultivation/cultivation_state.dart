part of 'cultivation_cubit.dart';

@immutable
sealed class CultivationState extends Equatable {
  final TuLuyenGioi idTuLuyen;
  final TuLuyenModel tuLuyen;

  const CultivationState({
    required this.idTuLuyen,
    required this.tuLuyen,
  });

  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class CultivationInitial extends CultivationState {
  const CultivationInitial({
    super.idTuLuyen = TuLuyenGioi.quocVuongVanTue,
    super.tuLuyen = const TuLuyenModel.empty(),
  });
}
