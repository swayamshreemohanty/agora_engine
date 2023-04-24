import 'package:agora_sdk_engine/communication/model/agora_creds_model.dart';
import 'package:agora_sdk_engine/communication/model/agora_engine_type_enum.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'agora_av_manager_state.dart';

class AgoraAvManagerCubit extends Cubit<AgoraAvManagerState> {
  AgoraAvManagerCubit() : super(LoadingAgoraAVManager());

  RtcEngine? _engine;

  void _engineConnected({
    required bool localUserConencted,
    int? remoteUserUID,
    required String channelId,
    required RtcEngine rtcEngine,
    bool remoteUserMuteAudio = false,
    bool remoteUserMuteVideo = false,
  }) {
    if (isClosed) {
      return;
    }
    emit(LoadingAgoraAVManager());
    emit(AgoraAVEngineConencted(
      localUserConencted: localUserConencted,
      remoteUserUID: remoteUserUID,
      channelId: channelId,
      rtcEngine: rtcEngine,
      remoteUserMuteAudio: remoteUserMuteAudio,
      remoteUserMuteVideo: remoteUserMuteVideo,
    ));
  }

  Future<void> initializeRTCEngine(
    RtcEngine engine, {
    required AgoraCredentialsModel agoraCredentialsModel,
    required AgoraEngineType agoraEngineType,
  }) async {
    try {
      _engine = engine;
      // retrieve permissions
      await [Permission.microphone, Permission.camera].request();

      await _engine!.initialize(RtcEngineContext(
        appId: agoraCredentialsModel.appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      final channelId = agoraCredentialsModel.channelName;
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            _engineConnected(
              localUserConencted: true,
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            _engineConnected(
              localUserConencted: true,
              remoteUserUID: remoteUid,
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            _engineConnected(
              localUserConencted: true,
              remoteUserUID: null, //set remote id to null
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onLeaveChannel: (connection, stats) {
            // _remoteUid = null;
            _engineConnected(
              localUserConencted: true,
              remoteUserUID: null, //set remote id to null
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onUserMuteAudio: (connection, remoteUid, muted) {
            _engineConnected(
              localUserConencted: true,
              remoteUserUID: remoteUid,
              channelId: channelId,
              rtcEngine: _engine!,
              remoteUserMuteAudio: muted,
            );
          },
          onUserMuteVideo: (connection, remoteUid, muted) {
            _engineConnected(
              localUserConencted: true,
              remoteUserUID: remoteUid,
              channelId: channelId,
              rtcEngine: _engine!,
              remoteUserMuteVideo: muted,
            );
          },

          //TODO:Need to check
          // onRejoinChannelSuccess: (connection, elapsed) {
          //   Fluttertoast.showToast(msg: "Remote user $elapsed re joined");
          //   _engineConnected(
          //     localUserConencted: true,
          //     remoteUserUID: elapsed,
          //     channelId: channel,
          //     rtcEngine: _engine!,
          //   );
          // },
          onTokenPrivilegeWillExpire:
              (RtcConnection connection, String token) {},
        ),
      );

      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      if (agoraEngineType == AgoraEngineType.video) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      }
      await _engine!.joinChannel(
        token: agoraCredentialsModel.token,
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      emit(AgoraAVManagerError(error: e.toString()));
    }
  }

  Future<void> audioMuteUnmute(bool mute) async {
    await _engine!.muteLocalAudioStream(mute);
  }

  Future<void> videoMuteUnmute(bool mute) async {
    await _engine!.muteLocalVideoStream(mute);
  }
}
