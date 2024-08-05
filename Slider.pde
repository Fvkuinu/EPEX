class Slider {
  String name;
  int min, max, value, l, posX, posY;
  float posV;
  color slclr, texclr;
  Slider(String cname, int cposX, int cposY, int clengh, int cmin, int cmax, int cvalue, color cslclr, color ctexclr) {
    name = cname;
    min = cmin;
    max = cmax;
    l = clengh;
    value = cvalue;
    posX = cposX;
    posY = cposY;
    posV = map(value, min, max, posX, posX+l);
    slclr = cslclr;
    texclr = ctexclr;
  }

  int update() {
    rectMode(CENTER);
    textSize(30);
    textAlign(LEFT, CENTER);
    stroke(200, 200, 200);
    strokeWeight(15);
    noStroke();
    line(posX, posY, l+posX, posY);
    stroke(slclr);
    strokeWeight(10);
    line(posX, posY, posV, posY);
    strokeWeight(3);
    stroke(200, 200, 200);
    noStroke();
    fill(slclr);
    ellipse(posV, posY, 25, 25);
    if (mouseX >= posX-25 && mouseX <= posX+l+25 && mouseY >= posY-20 && mouseY <= posY+20) {
      if (mousePressed) {
        posV = mouseX;
        posV = constrain(posV, posX, posX+l); 
      }
    }
    fill(texclr);
    text(name, posX, posY-45);
    fill(texclr);
    text(value, posX+l+20, posY-5);
    value = (int)map(posV, posX, posX+l, min, max);
    return value;
  }
}
