import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

class Enemy implements CS, Ray{
  
  //敵の出現位置
  float posx, posy, posz;
   float bodyW, bodyH, bodyD;
   float body2W, body2H, body2D;
   float legW, legH, legD;
   float leg2W, leg2H, leg2D;
   float leg3W, leg3H, leg3D;
   float heartW, heartH, heartD;
   float armW, armH, armD;
   float arm2W, arm2H, arm2D;
   float arm3W, arm3H, arm3D;
   float headR;
  PVector sRayBody, eRayBody;
  PVector sRayBody2, eRayBody2;
   PVector sRayLeg, eRayLeg;
   PVector sRayLeg2, eRayLeg2;
   PVector sRayLeg3, eRayLeg3;
   PVector sRayHead, eRayHead;
   PVector sRayHeart, eRayHeart;
   PVector sRayArm, eRayArm;
   PVector sRayArm2, eRayArm2;
   PVector sRayArm3, eRayArm3;
      Music music1;
   Music music2;
   Minim minim;
   private int bullet = 0;
   private int hp = 100;
  private PVector sRayEnemy, eRayEnemy;
  private int time = 0;
  private int timeShoot = 290;
  private boolean shoot = false;
  private boolean isMusic = true;
  private float theta;
  Enemy(PApplet parent) {
    minim = new Minim(parent);
     music1 = new Music(minim, "rifleFullAuto.wav");
    music2 = new Music(minim, "rifleReload.wav");
    
    bodyW = 80; bodyH = 60; bodyD = 50;
    body2W = 50; body2H = 60; body2D = 70;
    legW = 25; legH = 25; legD = 87;
    leg2W = 28; leg2H = 28; leg2D = 87;
    leg3W = 28; leg3H = 28; leg3D = 170;
    heartW = 20; heartH = 65; heartD = 20;
    armW = 20; armH = 50; armD = 20;
    arm2W = 20; arm2H = 80; arm2D = 20;
    headR = 27;
    theta = random(0, 2*PI);
    int[] isCollision = new int[wall.length];
    for(int i = 0; i < isCollision.length; i++){
      isCollision[i] = 0;
    }
    posz = 0;

    do{
      //enemySpawn(-880, -700) kara (1200, 380)
      posx = (int)random(-880, 1200); posy = (int)random(-700, 380);
      for(int i = 0; i < wall.length; i++){
        isCollision[i] = wall[i].colRect(posx, posy);
      }
    }while(max(isCollision) == 1);
    
  }
  void update() {
    PVector sRay = gun.s; 
    PVector eRay = gun.e;
    
    pushMatrix();
      
      translate(posx, posy, posz);
      rotateZ(theta);
      
      
      shape(enemyObj.get(time/2)); 
      //line(0, 0, 50, 0, -100, 50);
      sRayEnemy = localToWorld(0, 0, 50);
      eRayEnemy = localToWorld(0, -100, 50);
    popMatrix();
    if(!alive() && time < (enemyObj.size()-1)*2){
        time++;
    }
    if(!alive()){
      if(isMusic){
        isMusic = false;
        music1.bye();
        music2.bye();
      }
      return;
    }
    pushMatrix();
      noFill();
      translate(posx, posy, posz);
      rotateZ(theta);
      translate(0, 0, 10);
      rotateZ(-PI/6);
      //box(bodyW, bodyH, bodyD);
      sRayBody = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayBody = worldToLocal(eRay.x, eRay.y, eRay.z);
      //boolean c = rayRect(sRay, eRay, 70, 60, 80);
      //line(sRay.x, sRay.y, sRay.z, eRay.x, eRay.y, eRay.z);
      //println(c);     
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(0, 0, -40);
      rotateZ(-PI/6);
     // box(body2W, body2H, body2D);
      sRayBody2 = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayBody2 = worldToLocal(eRay.x, eRay.y, eRay.z);
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(0,0, +3);
      rotateZ(-PI/6);
     // box(heartW, heartH, heartD);
      sRayHeart = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayHeart = worldToLocal(eRay.x, eRay.y, eRay.z);    
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(-14, +20, -190);
      rotateY(-PI/12);
      rotateX(PI/12);
      //box(legW, legH, legD);
      sRayLeg = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayLeg = worldToLocal(eRay.x, eRay.y, eRay.z);
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(-17, +12, -100);
      rotateY(PI/12);
      //box(leg2W, leg2H, leg2D);
      sRayLeg2 = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayLeg2 = worldToLocal(eRay.x, eRay.y, eRay.z);
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(+20, -32, -155);
      rotateX(-PI/26);
      rotateY(-PI/34);
      //box(leg3W, leg3H, leg3D);
      sRayLeg3 = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayLeg3 = worldToLocal(eRay.x, eRay.y, eRay.z);
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(-15, -15, +56);
      //sphere(headR);
      sRayHead = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayHead = worldToLocal(eRay.x, eRay.y, eRay.z);
      //boolean s = raySphere(sRay, eRay, 27);
      //println(s);
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(+30, -50, +5);
      rotateX(PI/6);
      //box(armW, armH, armD);
      sRayArm = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayArm = worldToLocal(eRay.x, eRay.y, eRay.z);
    popMatrix();
    pushMatrix();
    translate(posx, posy, posz);
      rotateZ(theta);
      translate(+5, -80, +5);
      rotateZ(-PI/6);
      rotateX(-PI/10);
      
      //box(arm2W, arm2H, arm2D);
      sRayArm2 = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayArm2 = worldToLocal(eRay.x, eRay.y, eRay.z);
    popMatrix();
    
    if(search(sRayEnemy.x, sRayEnemy.y, sRayEnemy.z, eRayEnemy.x, eRayEnemy.y, eRayEnemy.z)){
      if(music1.isPlay()){
        bullet++;
        if(bullet%6 == 5){
          if(random(100) < 10){
            player.hit();
          }
        }       
      }
      shoot = true;
    }
    if(shoot){
      shoot();
    }
    //println(hp);
  }
  boolean alive(){
    if(hp > 0){
      return true;
    }
    return false;
  }
  void hitHead(){
    hp -= 100;
  }
  void hitBody(){
    hp -= 50;
  }
  void hitLeg(){
    hp -= 10;
  }
  void shoot(){
    timeShoot++;
    if(timeShoot%300 == 0){
      music1.start();
    }
    if(timeShoot%300 == 155){
      music2.start();
      
    }
    if(timeShoot%300 == 290){
      shoot = false;
    }
  }
  //敵がplayerを発見したか確認
  boolean search(float sx, float sy, float sz, float ex, float ey, float ez){
    PVector enemyCenter = new PVector(ex-sx, ey-sy);
    PVector enemyToPlayer = new PVector(camx-sx, camy-sy);
    if(!sector(enemyCenter, enemyToPlayer))  return false;
    if(!ray(sx, sy, sz))  return false;
    return true;
  }
  //指定の角度内に入っているか確認
  boolean sector(PVector v1, PVector v2){
    float  cosTheta = v1.dot(v2)/(v1.mag()*v2.mag());
    if(cosTheta >= cos(PI/4))  return true;
    return false;
  }
  //rayが一番みじかいものがどうか確認
  boolean ray(float px, float py, float pz){
    PVector vp = new PVector(px, py, pz);
    PVector vd = new PVector(camx, camy, camz);
    //float colll = 242424;
    ////pushMatrix();
    ////  translate(camx, camy, camz);
    ////  rotate(radians(cam.thetaH));
    ////  //cameraの座標からcpuの距離を計算
    ////  lovp = worldToLocal(px, py, pz);      
    ////  float playerDist = lovp.mag();
    ////popMatrix();
    ////line(vp.x, vp.y, vp.z, vd.x, vd.y ,vd.z);
    ////100 80 200
    //pushMatrix();
    //translate(camx, camy, camz);
    //  vp = worldToLocal(px, py, pz);
    //  vd.set(0, 0, 0);
    //  line(vp.x, vp.y, vp.z, 0, 0, 0);
    //  colll = rayRect(vp, vd, 10, 10, 200);
    //popMatrix();
    
    for(int i = 0; i < wall.length; i++){
      pushMatrix(); 
        translate(wall[i].tx, wall[i].ty, wall[i].tz);
        vp = worldToLocal(px, py, pz);
        vd = worldToLocal(camx, camy, camz);

      popMatrix();
      float wallDist = rayRect(vp, vd, wall[i].W, wall[i].H, wall[i].D);
      
      if(wallDist < 1)  {
        return false;
      }
    }
    //プレイヤーとcpuの間に壁があるか確認
    return true;
  }
  //ray と直方体の交差判定
  @Override
    float rayRect(PVector vp, PVector vd, float x, float y, float z) {
   float col = 214748364;
    vd.sub(vp.x, vp.y, vp.z); 
    float[] whd = {x/2.0, y/2.0, z/2.0};
    float[] p = {vp.x, vp.y, vp.z}; 
    float[] d = {vd.x, vd.y, vd.z};
    float[] t1 = new float[3]; 
    float[] t2 = new float[3];
    for (int i = 0; i < 3; i++) {
      if (d[i] == 0) {
        if (p[i] <= whd[i] && p[i] >= -whd[i]) {
          t1[i] = 0; 
          t2[i] = 214748364;
          break;
        } else return col;
      } else if (d[i] > 0) {
        t1[i] = (-whd[i]-p[i])/d[i]; 
        t2[i] = (whd[i]-p[i])/d[i];
      } else if (d[i] < 0) {
        t1[i] = (whd[i]-p[i])/d[i]; 
        t2[i] = (-whd[i]-p[i])/d[i];
      }
      if (t1[i] < 0) t1[i] = 0;
    }
    if(max(t1) <=  min(t2)) {
      col = min(t2);
    }
    return col;
  }
  //rayと球の交差判定
  @Override
    float raySphere(PVector vp, PVector vd, float r) {
    float col = 2147483646;
    vd.sub(vp.x, vp.y, vp.z);
    float B = vp.dot(vd);
    float A = sq(vd.mag());
    float C = sq(vp.mag())-sq(r);
    if(sq(B)-A*C >= 0){
      float D = (sqrt(sq(B)-A*C))/A;
      float t1 = -B/A+D;
      float t2 = -B/A-D;
      if(t1 <= t2) col = t1;
      if(t2 < t1) col = t2;
    }
    return col;
  }
  //world座標からlocal座標に変換
  @Override
    PVector worldToLocal(float x, float y, float z) {
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
    PVector localToWorld(float x, float y, float z) {
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
