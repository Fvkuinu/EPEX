import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class Music {

  AudioPlayer song;

  Music(Minim minim, String fname) {
    song = minim.loadFile(fname);
  }

  void start() {
    song.play(0);
  }

  void stop() {
    song.close();
  }
  
  void intermit(){
    song.pause();
  }
  
  boolean isPlay(){
    return song.isPlaying();
  }
  
  void bye(){
    song.close();
  }
}
