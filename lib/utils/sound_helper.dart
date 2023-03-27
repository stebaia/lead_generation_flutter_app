import 'package:audioplayers/audioplayers.dart';

class SoundHelper {
  static void play(int value, AudioPlayer player) async {
    switch (value) {
      case 0:
        {
          String alarmAudioPath = "beep.mp3";
          await player.setSourceAsset(alarmAudioPath);
          await player.play((AssetSource(alarmAudioPath)));
          break;
        }
      case 1:
        {
          String alarmAudioPath = "ok.mp3";
          await player.setSourceAsset(alarmAudioPath);
          await player.play((AssetSource(alarmAudioPath)));
          break;
        }
      case 2:
        {
          String alarmAudioPath = "error.wav";
          await player.setSourceAsset(alarmAudioPath);
          await player.play((AssetSource(alarmAudioPath)));
          break;
        }
    }

    //player.play();
  }
}