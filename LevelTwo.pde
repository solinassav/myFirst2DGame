public class LevelTwo {
  public Nibba myNibba;
  public Grinch[] Grinch= new Grinch [1000];
  public float scala;
  public int numeroGrinch;
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
    numeroGrinch=0;

    for (int i = 0; i < 5; i++) {
      Grinch[i] = new Grinch(scala);
      numeroGrinch++;
    }
    myNibba=new Nibba(scala, width/2, height/2);
    startMillis=millis();
  }
  void draw() {
    background(70); 
    if (millis()-startMillis>spawnTime && numeroGrinch<20) {
      if (spawnTime>1000)
        spawnTime-=50;
      Grinch[numeroGrinch] = new Grinch(scala);   
      numeroGrinch++;
      startMillis=millis();
    }
    myNibba.drawNibba();
    myNibba.setColpito(false);
    myNibba.setCollision(false);
    kills = 0;
    for (int i = 0; i < numeroGrinch; i++) {

      if (Grinch[i].isAlive()) {
        if (Grinch[i].getCollision(myNibba.getCentreX(), myNibba.getCentreY())) {
          myNibba.setCollision(true);
        }
        if (Grinch[i].getColpito()) {
          myNibba.setColpito(true);
        }      
        Grinch[i].drawEnemies(myNibba.getShotX(), myNibba.getShotY());
      } else {
        kills++;
      }
    }
    textSize(30);
    text("SCORE: "+kills, 100, 100);
  }
}