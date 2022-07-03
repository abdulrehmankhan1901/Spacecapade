import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:spacecapade/game/game.dart';

class AudioPlayer extends Component with HasGameRef<SpacecapadeGame> {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache
        .loadAll(['spaceman.wav', 'laser1.ogg', 'powerUp6.ogg']);
    return super.onLoad();
  }

  void playBgm(String filename) {
    FlameAudio.bgm.play(filename, volume: 0.25);
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void playSfx(String filename) {
    FlameAudio.play(filename, volume: 1);
  }
}
