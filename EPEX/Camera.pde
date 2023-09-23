public class Camera implements CS{
  float px, py, pz, tx, ty, tz, ux, uy, uz, speed, thetaH, thetaV;
  float ppx, ppy, ppz;
  float a, b, sprint, speedStance;
  int keyFR, keyRL;
  float xxx;
  PVector up = new PVector();
  PVector target = new PVector();
  private int fov;
  private boolean isSprint = false;
  private float speedLean = 0.9;
  PApplet parent;
  public Camera(){
  }
  Camera(PApplet parent, int cx, int cy , int cz){
    //<camera>
    this.parent = parent;
    try {
      parent.registerMethod("dispose", this);
      parent.registerMethod("pre", this);
    } 
    catch (Exception e) {
    }
    //</camera>
    px = cx; py = cy; pz = cz;
    tx = 0; ty = -100; tz = 0;
    ux = 0; uy = 0; uz = -1.0;
    speed = 1;
    thetaV = 180;
    thetaH = 0;
    a = 0.6; 
    sprint = 1;
    fov = 70;
  }
  //<camera>
  public void dispose() {
    parent.unregisterMethod("dispose", this);
    parent.unregisterMethod("pre", this);
  }
  public void pre() {
    update();
  }
  //</camera>
  void update(){
    if(sceneNumber != 1 || isMenu){
      return;
    }
    perspective(radians(fov), float(width)/float(height), 1.0, 5000.0); //fov-20がextend
    bot.mouseMove(1920/2, 1080/2);  //マウス座標を中心に変更  *旧ロボット
    //中心（マウス固定）からのマウスの移動距離によって視点移動角度を算出  *旧ロボット
    thetaH += mouseSensitivity/400.0*(mouseX-width/2.0);
    //縦の視野は上下180°分に固定
    
    thetaV += mouseSensitivity/400.0*(mouseY-height/2.0);
    thetaV = constrain(thetaV, 91, 269);
    parent.camera(0, 0, 3200, 0, 0, 0, 0, -1, 0);  //作業用カメラ視点
    PMatrix3D mat = (PMatrix3D)getMatrix();  //モデルビュー行列の取得
    mat.invert();  // 逆行列   
    pushMatrix();
      translate(px, -py, pz);
      rotate(radians(thetaH));
      rectMode(CENTER);
      fill(255);
      //box(100, 80, 200);
      //ellipse(0, 0, 50, 50);
      fill(255, 0, 0);
      ellipse(0, -100, 10, 10);
      PVector camera_pos = localToCamera(0, 100*cos(radians(thetaV)), 100*sin(radians(thetaV)));
      mat.mult( new PVector( camera_pos.x, camera_pos.y, camera_pos.z ), target );  //カメラ座標系のtargetをグローバル座標に変換
      tx = target.x; ty = target.y; tz = target.z;     
    popMatrix();
    //カメラ移動(座標計算)
    move();
    if(!keyState[4]){
      parent.camera(px, -py, pz, tx, ty, tz, ux, uy, uz);
     PMatrix3D cameraInv = ((PGraphicsOpenGL)g).cameraInv;
      if(keyState[5]) {
        xxx += 0.04;
      }
      if(keyState[6]) {
        xxx -= 0.04;
      }
      if(!keyState[5] && !keyState[6]){
        speedLean = 0.9;
        if(abs(xxx) < 0.03){
          xxx = 0;
        }
        if(xxx < 0){
          xxx += 0.04;
        }
        if(xxx > 0){
          xxx -= 0.04;
        }
      }
      else{
        speedLean = 0.6;
      }
      xxx = constrain(xxx, -0.5, 0.5);
      PVector mmm = new PVector(xxx, 1, 0);

      cameraInv.mult(mmm, up);
      stroke(0, 255, 0);
      line(px, -py, pz, up.x, up.y, up.z);
      stroke(0, 0, 255);
      line(px, -py, pz, tx, ty, tz);

      
      
      
      parent.camera(px-(up.x-px)*30, -py-(up.y+py)*30, pz-abs(xxx*10), tx, ty, tz, up.x-px, up.y+py, up.z-pz);
      camx = px-(up.x-px)*30 ; camy = -py-(up.y+py)*30; camz = pz-abs(xxx*10);
    }
    
    //else parent.camera(0,0,0, 0, 0, 0, 0, 1, 0);
  }
  
  private void move(){
    //スプリントしているか
    if(keyState[7]){
      sprint = 1.5;
      isSprint = true;
    }
    else{
      sprint = 1;
      isSprint = false;
    }
    //w,a,s,d,押されているキー数を数える
    keyFR = 1; keyRL = 1;
    for(int i = 0; i < 4; i++){
      if(keyState[i]){
        if(i%2 == 0)
          keyFR = 1-keyFR;
        else
          keyRL = 1-keyRL;
      }
    }
    //2つ以上なら速度は1/root2にする
    b = (keyFR==0 && keyRL==0) ? 1.0 : 1.41;
    int moveX = 1;  int moveY = 1;
    //押されているキーによって移動方向を決定
    if(keyState[0]){
          py += speed*cos(radians(thetaH))*b*sprint*speedStance*speedLean;
          px += speed*sin(radians(thetaH))*b*sprint*speedStance*speedLean;
          moveY = 1-moveY;
    }
    if(keyState[2]){
          py -= speed*cos(radians(thetaH))*b*sprint*speedStance*speedLean;
          px -= speed*sin(radians(thetaH))*b*sprint*speedStance*speedLean;
          moveY = 1-moveY;
    }
    if(keyState[1]){
          px -= speed*cos(radians(thetaH))*b*sprint*speedStance*speedLean;
          py += speed*sin(radians(thetaH))*b*sprint*speedStance*speedLean;
          moveX = 1-moveX;
    }
    if(keyState[3]){
          px += speed*cos(radians(thetaH))*b*sprint*speedStance*speedLean;
          py -= speed*sin(radians(thetaH))*b*sprint*speedStance*speedLean;
          moveX = 1-moveX;
    }
    //for(int i = 0; i < wall.length; i++){
    //  wall[i].col();
    //}
    //println(wall[0].col(px, -py));
    for(int i = 0; i < wall.length; i++){
      int col = wall[i].col(px, -py);
      if(col == 1) {
        px = ppx;
      }
      if(col == 2) {
        py = ppy;
      }
      if(col == 3){
        px = ppx;
        py = ppy;
      }
    }
    ellipse(px, -py, 100, 100);
    ppx = px; ppy = py; ppz = pz;
    if(moveX == 0 || moveY == 0){
      if(isSprint){
        if(music[8].isPlay()){
          music[8].intermit();
        }
        if(!music[7].isPlay()){
          music[7].start();
        }
      }
      else{
        if(music[7].isPlay()){
          music[7].intermit();
        }
        if(!music[8].isPlay()){
          music[8].start();
        }
      }
    }
    else{
      if(music[7].isPlay()){
          music[7].intermit();
        }
      if(music[8].isPlay()){
          music[8].intermit();
      }
    }
  }
  void speedIsoscelesStance(){
    if(mouseButtonState[1]){
      speedStance = 0.7;
    }
    else{
      speedStance = 1.55;
    }
  }
  void speedExtend(){
    if(mouseButtonState[1]){
      speedStance = 0.6;
    }
    else{
      speedStance = 1.3;
    }
  }
  void speedCombatHigh(){
    if(mouseButtonState[1]){
      speedStance = 1.3;
    }
    else{
      speedStance = 1.3;
    }
  }
  void recoilIsoscelesStance(){
    thetaV -= random(PI, 1.5*PI);
    thetaH += random(-PI/2, PI/2);
  }
  
  void recoilExtend(){
    thetaV -= random(PI/2, PI);
    thetaH += random(-PI/6, PI/6);
  }
  
  void fovIsoscelesStance(){
    if(fov >= 72){
      fov -= 3;
    }
    if(fov <=  68){
      fov += 3;
    }
    fov = constrain(fov, 60, 90);
  }
  
  void fovExtend(){
    fov -= 3;
    fov = constrain(fov, 60, 90);
  }
  void fovCombatHigh(){
    fov += 3;
    fov = constrain(fov, 60, 90);
  }
  //world座標からlocal座標に変換
  @Override
  PVector worldToLocal(float x, float y, float z){
    PVector in = new PVector(x, y, z);
    PVector out = new PVector();
    PMatrix3D modelview = ((PGraphicsOpenGL)g).modelview.get();
    PMatrix3D cameraInv = ((PGraphicsOpenGL)g).cameraInv.get();
    cameraInv.apply(modelview);
    cameraInv.invert();
    cameraInv.mult(in, out); 
    return out;
  }
  //local座標からworld座標に変換
  @Override
  PVector localToWorld(float x, float y, float z){
    PVector in = new PVector(x, y, z);
    PVector out = new PVector();
    PMatrix3D modelview = ((PGraphicsOpenGL)g).modelview.get();
    PMatrix3D cameraInv = ((PGraphicsOpenGL)g).cameraInv.get();
    cameraInv.apply(modelview);
    cameraInv.mult(in, out); 
    return out;
  }
  //camera座標 から local座標に変換すると思われる（未検証）
  @Override
   PVector cameraToLocal(float x, float y, float z) {
    PVector in = new PVector(x, y, z);
    PVector out = new PVector();
    PMatrix3D current_matrix = new PMatrix3D();
    getMatrix(current_matrix);  
    current_matrix.invert();
    current_matrix.mult(in, out);
    return out;
  }
  //local座標 から camera座標に変換する
  @Override
   PVector localToCamera(float x, float y, float z) {
    PVector in = new PVector(x, y, z);
    PVector out = new PVector();
    PMatrix3D current_matrix = new PMatrix3D();
    getMatrix(current_matrix);  
    current_matrix.mult(in, out);
    return out;
  }
}
