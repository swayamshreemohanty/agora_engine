// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'agora_av_manager_cubit.dart';

abstract class AgoraAvManagerState extends Equatable {
  const AgoraAvManagerState();

  @override
  List<Object> get props => [];
}

class LoadingAgoraAVManager extends AgoraAvManagerState {}

class AgoraAVManagerError extends AgoraAvManagerState {
  final String error;
  const AgoraAVManagerError({required this.error});

  @override
  List<Object> get props => [error];
}

class AgoraAVEngineConencted extends AgoraAvManagerState {
  final bool localUserConencted;
  final int? remoteUserUID;
  final String channelId;
  final RtcEngine rtcEngine;
  final bool remoteUserMuteAudio;
  final bool remoteUserMuteVideo;

  const AgoraAVEngineConencted({
    required this.localUserConencted,
    this.remoteUserUID,
    required this.channelId,
    required this.rtcEngine,
    this.remoteUserMuteAudio = false,
    this.remoteUserMuteVideo = false,
  });

  @override
  List<Object> get props => [
        localUserConencted,
        channelId,
        rtcEngine,
        remoteUserMuteAudio,
        remoteUserMuteVideo,
      ];

  AgoraAVEngineConencted copyWith({
    int? remoteUserUID,
    bool? mute,
  }) {
    return AgoraAVEngineConencted(
      localUserConencted: localUserConencted,
      remoteUserUID: remoteUserUID ?? this.remoteUserUID,
      channelId: channelId,
      rtcEngine: rtcEngine,
    );
  }
}
