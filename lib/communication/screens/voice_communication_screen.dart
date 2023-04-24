// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:agora_sdk_engine/communication/logic/agora_av_manager/agora_av_manager_cubit.dart';
import 'package:agora_sdk_engine/communication/logic/av_controller/av_controller_cubit.dart';
import 'package:agora_sdk_engine/communication/model/agora_creds_model.dart';
import 'package:agora_sdk_engine/communication/model/agora_engine_type_enum.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceCommunicationScreen extends StatefulWidget {
  final AgoraCredentialsModel agoraCredentialsModel;

  const VoiceCommunicationScreen({
    Key? key,
    required this.agoraCredentialsModel,
  }) : super(key: key);

  @override
  State<VoiceCommunicationScreen> createState() =>
      _VoiceCommunicationScreenState();
}

class _VoiceCommunicationScreenState extends State<VoiceCommunicationScreen> {
  final engine = createAgoraRtcEngine();

  @override
  void initState() {
    super.initState();
    context.read<AgoraAvManagerCubit>().initializeRTCEngine(engine,
        agoraEngineType: AgoraEngineType.voice,
        agoraCredentialsModel: widget.agoraCredentialsModel);
  }

  @override
  void dispose() {
    engine.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Call'),
      ),
      body: BlocBuilder<AgoraAvManagerCubit, AgoraAvManagerState>(
        builder: (context, agoraAVstate) {
          if (agoraAVstate is AgoraAVEngineConencted) {
            return Stack(
              children: [
                Center(
                  child: agoraAVstate.localUserConencted
                      ? agoraAVstate.remoteUserUID == null
                          ? const Text(
                              'Please wait for remote user to join',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 250,
                                ),
                                if (agoraAVstate.remoteUserMuteAudio)
                                  const Icon(
                                    Icons.mic_off,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                              ],
                            )
                      : const CircularProgressIndicator(),
                ),
                BlocBuilder<AvControllerCubit, AvControllerState>(
                  builder: (context, avControllerstate) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                context
                                    .read<AvControllerCubit>()
                                    .audioMuteUnmute();
                              },
                              shape: const CircleBorder(),
                              fillColor: avControllerstate.isAudioMuted
                                  ? Colors.blueAccent
                                  : Colors.white,
                              padding: const EdgeInsets.all(15),
                              child: Icon(
                                avControllerstate.isAudioMuted
                                    ? Icons.mic_off
                                    : Icons.mic,
                                color: avControllerstate.isAudioMuted
                                    ? Colors.white
                                    : Colors.blueAccent,
                                size: 20,
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                Navigator.pop(context);
                              },
                              shape: const CircleBorder(),
                              fillColor: Colors.redAccent,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }
        },
      ),
    );
  }
}
