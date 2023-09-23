class Shoot implements Ray, CS{
  float tWall;
  float[] tEnemy = new float[9];
  private float min;
  final private float minValue = 214748;
  private int hitNumber;
  private int enemyNumber;
  Shoot(){
  }
  void update(){
    min = 214748;
    for(int i = 0; i < em.length; i++){
      if(em[i].alive()){
          tEnemy[0] = raySphere(em[i].sRayHead, em[i].eRayHead, em[i].headR);
          tEnemy[1] = rayRect(em[i].sRayHeart, em[i].eRayHeart, em[i].heartW, em[i].heartH, em[i].heartD);
          tEnemy[2] = rayRect(em[i].sRayBody, em[i].eRayBody, em[i].bodyW, em[i].bodyH, em[i].bodyD);
          tEnemy[3] = rayRect(em[i].sRayBody2, em[i].eRayBody2, em[i].body2W, em[i].body2H, em[i].body2D);
          tEnemy[4] = rayRect(em[i].sRayLeg, em[i].eRayLeg, em[i].legW, em[i].legH, em[i].legD);
          tEnemy[5] = rayRect(em[i].sRayLeg2, em[i].eRayLeg2, em[i].leg2W, em[i].leg2H, em[i].leg2D);
          tEnemy[6] = rayRect(em[i].sRayLeg3, em[i].eRayLeg3, em[i].leg3W, em[i].leg3H, em[i].leg3D);
          tEnemy[7] = rayRect(em[i].sRayArm, em[i].eRayArm, em[i].armW, em[i].armH, em[i].armD);
          tEnemy[8] = rayRect(em[i].sRayArm2, em[i].eRayArm2, em[i].arm2W, em[i].arm2H, em[i].arm2D);
        for(int j = 0; j < tEnemy.length; j++){
          if(tEnemy[j] < min){
            min = tEnemy[j];
            enemyNumber = i;
            hitNumber = j;
          }
        }
      }
    }
    if(min == minValue){
      return;
    }
    if(!cheat){
      for(int i = 0; i < wall.length; i++){
        tWall = rayRect(wall[i].sRayWall, wall[i].eRayWall, wall[i].W, wall[i].H, wall[i].D);
        if(tWall <  min){
          return;
        }
      }
    }
    if(hitNumber <= 1){
      em[enemyNumber].hitHead();
    }
    else if(hitNumber <= 3){
      em[enemyNumber].hitBody();
    }
    else if(hitNumber <= 8){
      em[enemyNumber].hitLeg();
    }
    //println(tWall);
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
    float col = 214748364;
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
