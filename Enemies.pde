import processing.sound.*;
public class Enemies {
  SoundFile esplosioneEnemies;
  private float vel;
  private final PImage enemies;
  private final PImage enemiesSofferente;
  private final PImage fire;
  private float posX, posY;
  private float velX, velY;
  private float dimEnemiesX, dimEnemiesY;
  private float scala;
  private boolean isAlive;
  public int n;
  private int life;
  private boolean dead;
  private float deadTime;
  private boolean colpito;
  private int maxLife;
  private boolean collision;
  private float tempoCambioDirezione;
  // Costruttore
  public  Enemies(float scala, String nomeFileEsplosione, String nomeFileEnemiesDie, String nomeFileEnemies, String nomeFileFuoco) {
    tempoCambioDirezione=50;
    esplosioneEnemies = new SoundFile(NibbaGame.this, nomeFileEsplosione);
    vel=10;
    this.scala=scala;
    collision = false;
    velX =random(-10, 10)*scala;
    velY =random(-10, 10)*scala;
    colpito= false;
    maxLife=1;
    dead=false;
    life=0;
    isAlive=true;
    this.scala=scala;
    dimEnemiesX=150.0f * scala;
    dimEnemiesY=100.0f * scala;
    n = 0;
    enemiesSofferente = loadImage(nomeFileEnemiesDie);
    enemies = loadImage(nomeFileEnemies);
    fire = loadImage(nomeFileFuoco);
    posX = random(dimEnemiesX, width-dimEnemiesX);
    posY = random(dimEnemiesY, height-dimEnemiesY);
    image(enemies, posX, posY, dimEnemiesX, dimEnemiesY);
  }

  // Aggiorna disegno
  public void drawEnemies(float x, float y) {
    colpito=false;
    if (dead) {
      if ( deadTime <3) {
        image(fire, posX + dimEnemiesX/2, posY +dimEnemiesY/2, dimEnemiesX*deadTime, dimEnemiesY*deadTime);
        if (deadTime<1.5) {
          textSize(30);
          fill(255, 0, 0);
          text("KILLED", posX, posY);
          image(enemiesSofferente, posX, posY, dimEnemiesX*9/10, dimEnemiesY*9/10);
        }
        deadTime+=0.1;
      } else {
        posX=-2*dimEnemiesX;
        posY=-2*dimEnemiesY;
      }
    }
    if (isAlive) {
      aggiornaPos();
      updateLife(x, y);
      strokeWeight(3);
      stroke(0);
      fill(0, 190, 0);
      rect( posX - dimEnemiesX/10, posY-dimEnemiesY/10, dimEnemiesX, - dimEnemiesY/10);
      fill(255, 0, 0);
      rect( posX - dimEnemiesX/10, posY-dimEnemiesY/10, life * dimEnemiesX/maxLife, - dimEnemiesY/10);
      image(enemies, posX, posY, dimEnemiesX, dimEnemiesY);
    }
  }

  // Gestisce le collisioni
  public boolean getCollision(float x, float y) {

    if (isAlive) {
      if (x>posX+dimEnemiesX/10.0f && y>posY+dimEnemiesY/10.0f && x<posX+dimEnemiesX -dimEnemiesX/10.0f && y<posY+dimEnemiesY -dimEnemiesY/10.0f) {
        if (life<maxLife)
          life++;
        collision =true;
      } else {
        collision=false;
      }
      return collision;
    }
    return false;
  }

  // Gestisce i movimenti
  private void aggiornaPos() {
    if (n == tempoCambioDirezione) {
      velX =random(-vel, vel)*scala;
      velY =random(-vel, vel)*scala;
      n=0;
    }
    if (posX < 0 || posX > width- dimEnemiesX/2||collision) {
      velX = -velX;
    }
    if (posY < 0 || posY > height- dimEnemiesY||collision) {
      velY = -velY;
    }
    if (!isAlive) {
      velX=0;
      velY=0;
    }
    posX+=velX;
    posY+=velY;
    n++;
  }
  public boolean isAlive() {
    if (deadTime>=3)
      return false;
    return true;
  }

  // Gestisce la vita a seguito di colpi di proiettile
  private void updateLife(float x, float y) {
    colpito = false;
    if (isAlive) {
      if (x>posX+dimEnemiesX/10.0f && y>posY+dimEnemiesY/10.0f &&x<posX+dimEnemiesX -dimEnemiesX/10.0f && y<posY+dimEnemiesY -dimEnemiesY/10.0f) {
        if (life<maxLife)
          life++;
        colpito =true;
      } 
      if (life == maxLife) {
        esplosioneEnemies.play();
        dead=true;
        isAlive=false;
      }
    }
  }
  public void setDimX(float dim) {
    dimEnemiesX=dim;
  }
  public void setVel(float vel) {
    this.vel=vel;
  }
  public void setDimY(float dim) {
    dimEnemiesY=dim;
  }
  public void setTempoCambioDirezione(float t) {
    this.tempoCambioDirezione=t;
  }
  public void setMaxLife(int maxLife) {
    this.maxLife=maxLife;
  }
  // Restituisce true quando vengo colpito
  public boolean getColpito() {
    return colpito;
  }
}