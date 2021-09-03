import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/*
 * A [AudioStreamer] object is reponsible for connecting
 * to the native environment and streaming audio from the microphone.*
 */
const String EVENT_CHANNEL_NAME = 'audio_streamer.eventChannel';

class AudioStreamer {
  static int get sampleRate => 44100;

  static const EventChannel _noiseEventChannel =
      EventChannel(EVENT_CHANNEL_NAME);

  Stream<List<double>>? get stream => _stream;

  AudioStreamer() {
    _stream = _makeAudioStream((err) {
      debugPrint('AudioStreamer: makeAudioStream() error: $err');
    });
  }

  Stream<List<double>>? _stream;

  Stream<List<double>> _makeAudioStream(Function handleErrorFunction) {
    _stream ??= _noiseEventChannel
        .receiveBroadcastStream()
        .handleError((error) {
          _stream = null;
          handleErrorFunction(error);
        })
        .map((buffer) => buffer as List<dynamic>?)
        .map((list) => list!.map((e) => double.parse('$e')).toList());

    return _stream!;
  }
}
