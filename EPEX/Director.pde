class Director{
  Director(){
  }
  void update(){
    if(!player()){
      sceneNumber = 3;
    }
    if(!enemy()){
      sceneNumber = 2;
    }
  }
  boolean player(){
    return player.alive();
  }
  boolean enemy(){
    for(int i = 0; i < em.length; i++){
      if(em[i].alive()){
          return true;
      }
    }
    return false;
  }
}
