public class LevelOne{
public Nibba myNibba;
public Trump[] trump= new Trump [1000];
public float scala;
public int numeroTrump;
public int startMillis;
public int spawnTime, kills;
void keyPressed() {
  myNibba.keyPressed(key);
}
void mousePressed() {
  myNibba.mousePressed(mousePressed);
}
void mouseReleased() {
  myNibba.mousePressed(mousePressed);
}
void keyReleased() {
  myNibba.keyReleased(key);
}
void setup() {
  spawnTime=3000;
  scala=1.5;
  numeroTrump=0;

  for (int i = 0; i < 5; i++) {
    trump[i] = new Trump(scala);
    numeroTrump++;
  }
  myNibba=new Nibba(scala, width/2, height/2);
  startMillis=millis();
}
void draw() {
  background(70); 
  if (millis()-startMillis>spawnTime && numeroTrump<100) {
    if (spawnTime>1000)
      spawnTime-=100;
    trump[numeroTrump] = new Trump(scala);   
    numeroTrump++;
    startMillis=millis();
  }
  myNibba.drawNibba();
  myNibba.setColpito(false);
  myNibba.setCollision(false);
  kills = 0;
  for (int i = 0; i < numeroTrump; i++) {

    if (trump[i].isAlive()) {
      if (trump[i].getCollision(myNibba.getCentreX(), myNibba.getCentreY())) {
        myNibba.setCollision(true);
      }
      if (trump[i].getColpito()) {
        myNibba.setColpito(true);
      }      
      trump[i].drawEnemies(myNibba.getShotX(), myNibba.getShotY());
    } else {
      kills++;
    }
  }
  textSize(30);
  text("SCORE: "+kills, 100, 100);
}

}