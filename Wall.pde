class Wall implements CS{
  int tx, ty, tz;
  int x1, x2, y1, y2;
  int W, H, D;
  final private int r = 45;
  public PVector sRayWall, eRayWall;
  Wall(int cx1, int cy1, int cx2, int cy2){
    tx = (cx1+cx2); ty = (cy1+cy2); tz = 0;
    x1 = cx1*2; y1 = cy1*2; x2 = cx2*2; y2 = cy2*2;
    W = abs(cx2-cx1)*2; H = abs(cy2-cy1)*2; D = 500;
  }
  void update(){
    PVector sRay = gun.s; 
    PVector eRay = gun.e;
    pushMatrix();
      translate(tx, ty, tz);
      fill(100, 100, 100);
      stroke(0);
      strokeWeight(1);
      box(W, H, D);
      sRayWall = worldToLocal(sRay.x, sRay.y, sRay.z);
      eRayWall = worldToLocal(eRay.x, eRay.y, eRay.z);
    popMatrix();
  }
  //detail衝突判定（円と矩形を採用）
  int col(float xc, float yc){
    int col = 0;
    if(!colBroad(xc, yc)) return col;
    //円と矩形の衝突
    if(sq(x1-xc)+sq(y1-yc) < sq(r)) col = 3;
    if(sq(x2-xc)+sq(y1-yc) < sq(r)) col = 3;
    if(sq(x2-xc)+sq(y2-yc) < sq(r)) col = 3;
    if(sq(x1-xc)+sq(y2-yc) < sq(r)) col = 3;
    if((xc > x1)&&(xc < x2)&&(yc > y1-r)&&(yc < y2+r)) col = 2;      
    if((xc > x1-r)&&(xc < x2+r)&&(yc > y1)&&(yc < y2)) col = 1;
    return col;
  }
  //大きめの衝突判定（矩形同士を採用）
  boolean colBroad(float xc, float yc){
    boolean colB;
    colB = (abs(xc-tx) <= r+W/2 && abs(yc-ty) <= r+H/2) ? true: false;
    return colB;
  }
  //enemy用
  int colRect(float xc, float yc){
    int colB;
    colB = (abs(xc-tx) <= 50+W/2 && abs(yc-ty) <= 50+H/2) ? 1: 0;
    return colB;
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
