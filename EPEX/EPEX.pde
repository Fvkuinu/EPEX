//Robotのインポート
import java.awt.*;
import java.awt.Robot.*;
//minimのインポート
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Robot bot;
Camera cam;
Gun gun;
Enemy[] em;
Wall[] wall;
Wall2[] wall2;
Shoot shoot;
Player player;
Scene scene;
Director director;

// Make these available throughout the class
Minim minim;
Music[] music = new Music[9];
//キー入力を見る配列
public boolean[] keyState = new boolean[10];
public boolean[] mouseButtonState = new boolean[3];
//スタンスをみる配列
public int stance = 3;
public boolean reloading = false;
public boolean shooting = false;
public ArrayList<PShape> enemyObj = new ArrayList<PShape>();
public float camx, camy, camz;
public int sceneNumber = 1;
public boolean isMenu = false;
public int mouseSensitivity = 15;
public boolean banMenu = false;
public boolean cheat = false;
public boolean isShowKeyboardControls = true;
void setup() {
  fullScreen(P3D);
  //frameRate(90);
  //size(500, 500, P3D); 
  //カメラのインスタンス化
  cam = new Camera(this, 2200, 2500, 0);
  gun = new Gun();
  
  player = new Player();
  director = new Director();
  scene = new Scene();
  int hoge = 10;
  wall = new Wall[33];
  wall[0] = new Wall(-500, -500, -100, -470-hoge);
  wall[1] = new Wall(-500, -720, -470-hoge, -500);
  wall[2] = new Wall(-880, -350, -50, -320-hoge);
  wall[3] = new Wall(-880, -740, -100, -710-hoge);
  wall[4] = new Wall(-900, -740, -870-hoge, 400);
  wall[5] = new Wall(-900, 400, 1250, 430-hoge);
  wall[6] = new Wall(100, -720, 130-hoge, 50);
  wall[7] = new Wall(-490, -80, -300, -50-hoge);
  wall[8] = new Wall(-200, -80, -90, -50-hoge);
  wall[9] = new Wall(-90, -180, -60-hoge, -60);
  wall[10] = new Wall(-500, -330, -470-hoge, -80);
  wall[11] = new Wall(100, 172, 130-hoge, 400);
  wall[12] = new Wall(-100, -940, -70-hoge, -720);
  wall[13] = new Wall(50, -350, 100, -320-hoge);
  wall[14] = new Wall(540, -190, 570-hoge, 400);
  wall[15] = new Wall(120, -190, 250, -160-hoge);
  wall[16] = new Wall(360, -190, 540, -160-hoge);
  wall[17] = new Wall(120, -720, 560, -690-hoge);
  wall[18] = new Wall(540, -700, 570-hoge, -410);
  wall[19] = new Wall(710, -720, 1250, -690-hoge);
  wall[20] = new Wall(-90, -960, 920, -930-hoge);
  wall[21] = new Wall(920, -1380, 950-hoge, -940);
  wall[22] = new Wall(920, -1400, 1250, -1370-hoge);
  wall[23] = new Wall(1250, -1400, 1280-hoge, 400);
  wall[24] = new Wall(-90, -330, -60-hoge, -280);
  wall[25] = new Wall(-650, 110, -620-hoge, 230);
  wall[26] = new Wall(-740, 110, -650, 140-hoge);
  wall[27] = new Wall(-450, 200, -420-hoge, 400);
  wall[28] = new Wall(-300, 200, -270-hoge, 400);
  wall[29] = new Wall(980, -20, 1250, 10-hoge);
  wall[30] = new Wall(980, -360, 1250, -330-hoge);
  wall[31] = new Wall(700, -150, 800, 200);
  wall[32] = new Wall(300, 100, 400, 250);
  wall2 = new Wall2[7];
  wall2[0] = new Wall2(560, -720, 710, -700);
  wall2[1] = new Wall2(-50, -350, 50, -330);
  wall2[2] = new Wall2(-90, -280, -70, -180);
  wall2[3] = new Wall2(-300, -80, -200, -60);
  wall2[4] = new Wall2(-500, -500, -480, -350);
  wall2[5] = new Wall2(100, 50, 120, 172);
  wall2[6] = new Wall2(250, -190, 360, -170);
  em = new Enemy[10];
  for(int i = 0; i < em.length; i++){
    em[i] = new Enemy(this);
  }

  shoot = new Shoot();
  //Robot使うための処理
  try {
    bot = new Robot();
    bot.mouseMove(50, 50);
  }
  catch (AWTException e) {
    e.printStackTrace();
  }
  // Initialise sound resources
  minim =  new Minim(this);
  // Make the music object
  music[0] = new Music(minim, "shoot.wav");
  music[1] = new Music(minim, "noAmmo.wav");
  music[2] = new Music(minim, "reloadOut.wav");
  music[3] = new Music(minim, "reloadIn.mp3");
  music[4] = new Music(minim, "slide.wav"); 
  music[5] = new Music(minim, "rifleFullAuto.wav");
  music[6] = new Music(minim, "rifleReload.wav");
  music[7] = new Music(minim, "run.wav");
  music[8] = new Music(minim, "walk.wav");
  //noCursor();  //カーソルの非表示
  for (int i = 0; i < keyState.length; i++) {
    keyState[i] = false;
  }
  for (int i = 1; i <= 140; i++) { //140
    if(i%2 == 0){
      PShape obj = loadShape("EnemyDying_"+nf(i, 6)+".obj");
      enemyObj.add(obj);
    }
  }
  noCursor();
}

void draw() {
  if(cheat){
    hint(DISABLE_DEPTH_TEST);
  }
  scene.update();
  director.update();
}

void stop() {
  //  Stop the music
  for (int i = 0; i < music.length; i++) {
    music[i].stop();
  }
  // Release the sound resources
  minim.stop();
  super.stop();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT)  keyState[7] = true;
    
    
  }
  if(keyCode == ALT && cheat){
     banMenu = true;
  }
  if (keyCode == ESC){
    key = 0;
      if(isMenu){
        isMenu = false;
        noCursor();
      }
      else{
        isMenu = true;
        cursor();
      }
    }
    if (key == 'h' || key == 'H'){
      if(isShowKeyboardControls){
        isShowKeyboardControls = false;
      }
      else{
        isShowKeyboardControls = true;
      }
    }
    
  if (key == 'w' || key == 'W' || keyCode == UP) keyState[0] = true;
  if (key == 'a' || key == 'A' || keyCode == LEFT) keyState[1] = true;
  if (key == 's' || key == 'S' || keyCode == DOWN) keyState[2] = true;
  if (key == 'd' || key == 'D' || keyCode == RIGHT) keyState[3] = true;
  //if (key == 'f' || key == 'F') keyState[4] = true;
  if (key == 'v' || key == 'V') keyState[5] = true;
  if (key == 'b' || key == 'B') keyState[6] = true;
  if (key == 'r' || key == 'R') reloading = true;
  if (key == '1' || key == '!')  stance = 1;
  if (keyCode == 50)  stance = 2;
  if (key == '3' || key == '#')  stance = 3;
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT)  keyState[7] = false;
  }
  if (key == 'w' || key == 'W') keyState[0] = false;
  if (key == 'a' || key == 'A') keyState[1] = false;
  if (key == 's' || key == 'S') keyState[2] = false;
  if (key == 'd' || key == 'D') keyState[3] = false;
  //if (key == 'f' || key == 'F') keyState[4] = false;
  if (key == 'v' || key == 'V') keyState[5] = false;
  if (key == 'b' || key == 'B') keyState[6] = false;
}

void mousePressed() {
  if (mouseButton == LEFT)  mouseButtonState[0] = true;
  if (mouseButton == RIGHT)  mouseButtonState[1] = true;
  if (mouseButton == CENTER)  mouseButtonState[2] = true;
}

void mouseReleased() {
  if (mouseButton == LEFT)  mouseButtonState[0] = false;
  if (mouseButton == RIGHT)  mouseButtonState[1] = false;
  if (mouseButton == CENTER)  mouseButtonState[2] = false;
}
