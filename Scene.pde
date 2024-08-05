class Scene{
  PImage gameover;
  PImage gameclear;
  boolean isClicked = false;
  boolean isReleased = false;
  boolean isDialog = false;
  Slider MouseSensitivitySlider;
  color sliderClr = #dc143c;
  color textClr = #000000;
  Scene(){
    gameover = loadImage("text_gameover_e.png");
    gameclear = loadImage("text_gameclear_e.png");
    MouseSensitivitySlider = new Slider("Mouse Sensitivity", width/2-400, height/2+400, 800, 1, 100, 15, sliderClr, textClr);
  }
  void update(){
    if(banMenu){
      pushMatrix();
        ortho();
        resetMatrix();
        translate(-width/2.0, -height/2.0);
        hint(DISABLE_DEPTH_TEST);
        background(255, 50, 50);
        fill(255);
        textSize(120);
        textAlign(CENTER, CENTER);
        text("HACKER DETECTED", width/2.0, height/2.0-100);
        hint(ENABLE_DEPTH_TEST);
      popMatrix();
      return;
    }
    if(isMenu){
      pushMatrix();
          ortho();
          resetMatrix();
          translate(-width/2.0, -height/2.0);
          hint(DISABLE_DEPTH_TEST);
          background(200, 200, 200);
          if(isDialog){
            fill(255);
            stroke(0);
            rect(width/2.0, height/2.0, 1000, 500);
            fill(#c71585);
            textAlign(CENTER, CENTER);
            textSize(50);
            text("Are you sure you want to quit?", width/2.0, height/2.0-50);
            rect(width/2.0-225, height/2.0+150, 400, 75);
            rect(width/2.0+225, height/2.0+150, 400, 75);
            fill(255);
            text("Cancel", width/2.0-225, height/2.0+150);
            text("Confirm", width/2.0+225, height/2.0+150);
            
          }
          else{
          stroke(0);
          fill(100, 100, 100);
          rectMode(CENTER);
          rect(width/2.0, height/2.0-150, 400, 100);
          rect(width/2.0, height/2.0+150, 400, 100);
          textAlign(CENTER, CENTER);
          fill(255);
          textSize(50);
          text("Back", width/2.0, height/2.0-150);
          
          text("Quit Game", width/2.0, height/2.0+150);
          noStroke();
          fill(50, 50, 50);
          rect(width/2, height/2+400, 830, 25);
          mouseSensitivity = MouseSensitivitySlider.update();
          fill(255);
          noStroke();
          ellipse(width-50, 0+50, 50, 50);
          if(cheat){
            fill(255, 0, 0);
            ellipse(width-50, 0+50, 40, 40);
          }
          }
          
          strokeWeight(4);
          isClicked = false;
          if(mouseButtonState[0] && isReleased){
            isClicked = true;
            isReleased = false;
          }
          if(!mouseButtonState[0]){
            isReleased = true;
          }
          if(isClicked){
            if(isDialog){
            //  rect(width/2.0-225, height/2.0+150, 400, 75);
            //  rect(width/2.0+225, height/2.0+150, 400, 75);
            
            if(mouseX<=width/2.0-225+200 && mouseX>=width/2.0-225-200 && mouseY<=height/2.0+150+75/2 && mouseY>=height/2.0+150-75/2){
                isDialog = false;
              }
            if(mouseX<=width/2.0+225+200 && mouseX>=width/2.0+225-200 && mouseY<=height/2.0+150+75/2 && mouseY>=height/2.0+150-75/2){
                exit();
              }
            }
            else{
              if(dist(mouseX, mouseY, width-50, 0+50) <= 25){
                if(cheat){
                  cheat = false;
                }
                else{
                  cheat = true;
                }
              }
              if(mouseX<=width/2.0+200 && mouseX>=width/2.0-200 && mouseY<=height/2.0-150+50 && mouseY>=height/2.0-150-50){
                isMenu = false;
                noCursor();
              }
              if(mouseX<=width/2.0+200 && mouseX>=width/2.0-200 && mouseY<=height/2.0+150+50 && mouseY>=height/2.0+150-50){
                isDialog = true;
              }
            }
          }
          hint(ENABLE_DEPTH_TEST);
        popMatrix();
        return;
    }
    if(sceneNumber == 1){
      stroke(0);
      background(255);
      lights();
      //地面
      pushMatrix();
        fill(200, 200, 200);
        translate((1250-900), (400-1400), -270);
        box((1300+1000)*2, (1400+500)*2, 20);
      popMatrix();
      for (int i = 0; i < wall.length; i++) {
        wall[i].update();
      }
      for(int i = 0; i < wall2.length; i++){
        wall2[i].update();
      }
      cam.update();  //カメラの描画
      gun.update();
      for(int i = 0; i < em.length; i++){
        em[i].update();
      }
      if (shooting) {
        shoot.update();
      }
      player.update();
      pushMatrix();
        ortho();
        resetMatrix();
        translate(-width/2.0, -height/2.0);
        hint(DISABLE_DEPTH_TEST);
        fill(100, 100, 100, 100);
        noStroke();
        rectMode(CORNER);
        if(!isShowKeyboardControls){
          //rect(0+50, 0+50, 300, 50);
          //textSize(20);
          //textAlign(LEFT, CENTER);
          //fill(255);
          //translate(70, 70);
          //text("Show Keyboard Controls – H", 0, 0);
        }
        else{
          rect(0+50, 0+50, 500, 310);       
          textSize(20);
          textAlign(LEFT, CENTER);
          fill(255);
          translate(70, 70);
          text("Movement – W/A/S/D/", 0, 0);
          translate(0, 25);
          text("Fire – LeftMouseButton", 0, 0);
          translate(0, 25);
          text("Targeting – RightMouseButton", 0, 0);
          translate(0, 25);
          text("Reload – R", 0, 0);
          translate(0, 25);
          text("Primary Weapon 1 – 1", 0, 0);
          translate(0, 25);
          text("Primary Weapon 2 – 2", 0, 0);
          translate(0, 25);
          text("Unarm – 3", 0, 0);
          translate(0, 25);
          text("Peek Left – V", 0, 0);
          translate(0,25);
          text("Peek Right – B", 0, 0);
          translate(0, 25);
          text("Menu – ESC", 0, 0);
          translate(0, 25);
          text("Hide Keyboard Controls – H", 0, 0);
          if(cheat){
            translate(0, 25);
            text("??? – L-ALT", 0, 0);
          }
        }
        
        hint(ENABLE_DEPTH_TEST);
      popMatrix();
    }
    if(sceneNumber == 2){
      
        pushMatrix();
          ortho();
          resetMatrix();
          translate(-width/2.0, -height/2.0);
          hint(DISABLE_DEPTH_TEST);
          background(255);
          //textAlign(CENTER, CENTER);
          //textSize(50);
          //fill(255, 0, 0);
          //text("CLEAR", width/2.0, height/2.0);
          imageMode(CENTER);
          image(gameclear, width/2.0, height/2.0);
          rectMode(CENTER);
          stroke(0);
          fill(255);
          strokeWeight(2);
          rect(0+200, height-150, 100, 50);
          fill(0);
          textSize(30);
          textAlign(CENTER, CENTER);
          text("Esc", 0+200, height-150);
          textAlign(LEFT, CENTER);
          textSize(40);
          text("Menu", 0+280, height-150);
          
          
          
          hint(ENABLE_DEPTH_TEST);
        popMatrix();
    }
    if(sceneNumber == 3){
      
      pushMatrix();
          ortho();
          resetMatrix();
          translate(-width/2.0, -height/2.0);
          hint(DISABLE_DEPTH_TEST);
          background(255);
          //textAlign(CENTER, CENTER);
          //textSize(50);
          //fill(0, 0, 255);
          //text("GAME OVER", width/2.0, height/2.0);
          imageMode(CENTER);
          image(gameover, width/2.0, height/2.0);
          rectMode(CENTER);
          stroke(0);
          fill(255);
          strokeWeight(2);
          rect(0+200, height-150, 100, 50);
          fill(0);
          textSize(30);
          textAlign(CENTER, CENTER);
          text("Esc", 0+200, height-150);
          textAlign(LEFT, CENTER);
          textSize(40);
          text("Menu", 0+280, height-150);
          hint(ENABLE_DEPTH_TEST);
        popMatrix();
    }
  }
}
