class Player{
  private int hp = 100;
  Player(){
  }
  void update(){
  }
  void hit(){
    hp -= 10;
  }
  boolean alive(){
    if(hp > 0){
      return true;
    }
    return false;
  }
}
