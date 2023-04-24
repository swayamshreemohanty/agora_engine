// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'av_controller_cubit.dart';

class AvControllerState extends Equatable {
  final bool isAudioMuted;
  final bool isVideoMuted;
  const AvControllerState({
    this.isAudioMuted = false,
    this.isVideoMuted = false,
  });

  @override
  List<Object> get props => [isAudioMuted, isVideoMuted];

  AvControllerState copyWith({
    bool? isAudioMuted,
    bool? isVideoMuted,
  }) {
    return AvControllerState(
      isAudioMuted: isAudioMuted ?? this.isAudioMuted,
      isVideoMuted: isVideoMuted ?? this.isVideoMuted,
    );
  }
}
