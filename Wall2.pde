class Wall2{
  int W, H, D;
  int tx, ty, tz;
  Wall2(int cx1, int cy1, int cx2, int cy2){
    tx = (cx1+cx2); ty = (cy1+cy2); tz = 187;
    W = abs(cx2-cx1)*2; H = abs(cy2-cy1)*2; D = 126;
  }
  
  void update(){
    pushMatrix();
      translate(tx, ty, tz);
      fill(100, 100, 100);
      stroke(0);
      box(W, H, D);
    popMatrix();
  }
}
