class Gun implements CS{
  ArrayList<PShape> isoscelesStance = new ArrayList<PShape>();
  ArrayList<PShape> reload = new ArrayList<PShape>();
  ArrayList<PShape> extend = new ArrayList<PShape>();
  PShape isoscelesStanceNoAmmo;
  PShape extendNoAmmo;
  PShape combatHigh;
  PShape combatHighNoAmmo;
  PVector e = new PVector();
  PVector s = new PVector();
  boolean anm = false;
  boolean shootReady = true;
  int fc = 0;
  int time = 0;
  private float aimIsoscelesStance = 0;
  private float aimExtend = 0;
  private int ammo;
  Gun(){
    for(int i = 101; i <= 155; i++){ //155
      PShape obj = loadShape("M&P9reloadNormal1lowP_"+nf(i, 6)+".obj");
      reload.add(obj);
    }
    for(int i = 200; i <= 210; i++){ //210
      PShape obj = loadShape("M&P9shoot3LowP_"+nf(i, 6)+".obj");
      isoscelesStance.add(obj);
    }
    for(int i = 15; i <= 15; i++){ //28
      PShape obj = loadShape("M&P9shootExtendLowPoly_"+nf(i, 6)+".obj");
      extend.add(obj);
    }
    isoscelesStanceNoAmmo = loadShape("M&P9shoot3LowP.obj");
    extendNoAmmo = loadShape("M&P9shootExtendLowPoly.obj");
    combatHigh = loadShape("M&P9shootCombatHigh.obj");
    combatHighNoAmmo = loadShape("M&P9shootCombatHighLowPolyNoAmmo.obj");
    ammo = 18;
  }
  void update(){    
    if(reloading){
      anm = true;
      reload();
    }
    else{
      if(stance == 1){
        extend();
      }
      else if(stance == 2){
        isoscelesStance();
      }
      else if(stance == 3){
        combatHigh();
      }
    }  
    //pushMatrix();
    //  translate(camx, camy, camz);
    //  rotate(radians(cam.thetaH));
    //  //if(keyState[5]){
    //  //  translate(0, 40*cos(radians(cam.thetaV)), 40*sin(radians(cam.thetaV)));
    //  //  rotateX(radians(cam.thetaV+180));
    //  //  //sphere(10);
    //  //  //line(0,0,-10,0,-300,-10);
    //  //  s = localToWorld(0, 0, -10);
    //  //  e = localToWorld(0, -30, -10);
    //  //  shape(isoscelesStance.get(time%isoscelesStance.size()));
    //  //  time++;
    //  //}
    //  //else{
    //  //  translate(0, 25*cos(radians(cam.thetaV)), 25*sin(radians(cam.thetaV)));
    //  //  rotateX(radians(cam.thetaV+180));
    //  //  shape(reload.get(0));
    //  //  //shape(reload.get((time/2)%reload.size()));
        
    //  //}
    //  translate(0, 30*cos(radians(cam.thetaV)), 30*sin(radians(cam.thetaV)));
    //  rotateX(radians(cam.thetaV+180));
      
    //  //shape(extend.get(0));
    // // s = localToWorld(0,0,-5);
    // // e = localToWorld(0,-30,-5);
    // //line(0,0,-5,0,-30,-5);
    //popMatrix();
    //line(s.x, s.y, s.z, e.x, e.y, e.z);
    if(reloading){
      cam.speedCombatHigh();
    }
  }
  
  void isoscelesStance(){
    shooting = false;
    if(mouseButtonState[0] && !anm && shootReady){
      if(ammo > 0){
        shooting = true;
        anm = true; 
        shootReady = false;
        ammo--;
        time = 0; 
        music[0].start();
      }
      else{
        anm = true;
        time = 0;
        shootReady = false;
        music[1].start();
      }
    }
    if(!mouseButtonState[0]){
      shootReady = true;
    }
    if(anm){
      time++;
    }
    if(time >= isoscelesStance.size()){
      anm = false;  
      time = 0;
    }
    if(!mouseButtonState[1]){
      aimIsoscelesStance -= 1.2;
      cam.fovCombatHigh();
    }
    else{
      aimIsoscelesStance += 1.2;
      cam.fovIsoscelesStance();
    }
    aimIsoscelesStance = constrain(aimIsoscelesStance, 0.1, 15);
    
    pushMatrix();
      translate(camx, camy, camz-map(aimIsoscelesStance, 0.1, 15, 10, 0));
      rotate(radians(cam.thetaH));
      translate(0, aimIsoscelesStance*cos(radians(cam.thetaV)), aimIsoscelesStance*sin(radians(cam.thetaV)));
      rotateX(radians(cam.thetaV+180));
      rotateY(-atan2(cam.xxx, 1));
      //sphere(10);
      if(cheat){
        line(-0.6,0,-2.6,-0.6,-3000, -2.6);
      }
      s = localToWorld(-0.6,0,-2.6);
      e = localToWorld(-0.6,-30, -2.6);
      if(ammo > 0){
        shape(isoscelesStance.get(time));
      }
      else{
        shape(isoscelesStanceNoAmmo);
      }
    popMatrix();
    cam.speedIsoscelesStance();
    if(shooting){
      cam.recoilIsoscelesStance();
    }
  }
  
  void extend(){
    shooting = false;
    if(mouseButtonState[0] && !anm && shootReady){
      if(ammo > 0){
        shooting = true;
        anm = true; 
        shootReady = false;
        ammo--;
        time = 0; 
        music[0].start();
      }
      else{
        anm = true; 
        time = 0;
        shootReady = false;
        music[1].start();
      }
    }
    if(!mouseButtonState[0]){
      shootReady = true;
    }
    if(anm)  
      time++;
    if(time >= extend.size()){
      anm = false;  
      time = 0;
    }
    if(!mouseButtonState[1]){
      aimExtend += 1.7;
      cam.fovCombatHigh();
    }
    else{
      aimExtend -= 2.5;
      cam.fovExtend();
    }
    aimExtend = constrain(aimExtend, 0, 26);
    pushMatrix();
      translate(camx, camy, camz-map(aimExtend, 0, 26, 0, 18));
      rotate(radians(cam.thetaH));
      translate(0, 20*cos(radians(cam.thetaV)), 20*sin(radians(cam.thetaV)));
      rotateX(radians(cam.thetaV+180+aimExtend));
      rotateY(-atan2(cam.xxx, 1));
      if(ammo > 0){
        shape(extend.get(time));
      }
      else{
        shape(extendNoAmmo);
      }
      s = localToWorld(0,0,-5);
      e = localToWorld(0,-30,-5);
      if(cheat){
        line(1.3,0,-4,1.3,-3000,-4);
      }
    popMatrix();
    cam.speedExtend();
    //cam.fovExtend();
    if(shooting){
      cam.recoilExtend();
    }
  }
  
  void reload(){
    if(anm){
      time++;
      if(time == 40){
        music[2].start();
      }
      if(time == 70){
        music[3].start();
      }
      if(time == 100){
        music[4].start();
      }
    }
    if(time >= reload.size()*2){
      anm = false;  
      time = 0;
      reloading = false;
      stance = 2;
      if(ammo > 0){
        ammo = 18;
      }
      else{
        ammo = 17;
      }
    }
    pushMatrix();
      translate(camx, camy, camz);
      rotate(radians(cam.thetaH));
      translate(0, 15*cos(radians(cam.thetaV)), 15*sin(radians(cam.thetaV)));
      rotateX(radians(cam.thetaV+180));
      rotateY(-atan2(cam.xxx, 1));
      shape(reload.get(time/2));    
    popMatrix();
  }
  void combatHigh(){
    pushMatrix();
      translate(camx, camy, camz);
      rotate(radians(cam.thetaH));
      //translate(0, 50*cos(radians(cam.thetaV)), 50*sin(radians(cam.thetaV)));
      //rotateX(radians(cam.thetaV+180));
      if(ammo > 0){
        shape(combatHigh);
      }
      else{
        shape(combatHighNoAmmo);
      }
    popMatrix();
    cam.fovCombatHigh();
    cam.speedCombatHigh();
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
