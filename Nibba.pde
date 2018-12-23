
class Nibba {
  private final PImage fire;
  private SoundFile file;
  SoundFile esplosione;
  private float dieX, dieY;
  private float scala;
  private color marrone = color(118, 79, 46);
  private color nero=color(0, 0, 0);
  private float centreX, centreY, r, d, sopraccigliaY, sopraccigliaX, dimSopraccigliaX, dimSopraccigliaY, distanzaSopracciglia;
  private float x, y, deltaPupilleX, deltaPupilleY;
  private float deltaMagliettaX, deltaMagliettaY, dimMagliettaX, dimMagliettaY;
  private float deltaCentreY, dimPupille, movPupilleX=0, moveOr=0, moveVer=0;
  private float rangeMovePupi;
  private float shotX, shotY;
  private Boolean dirPupille=true, scalaPiu=false, scalaMeno=false;//true destra, false sinistra
  private int KEY_LEFT = 0;
  private int KEY_RIGHT = 1;
  private  int KEY_UP = 2;
  private boolean colpito;
  private int KEY_DOWN = 3;
  private boolean[] keysPressed = new boolean[] {false, false, false, false};
  private boolean isShooting = false;
  private float stateTime = 0.0f;
  private float startMillis;
  private boolean collision;
  private boolean isAlive;
  private int life, maxLife;
  private float deadTime=0;
  float x_, y_;
  float lastX, lastY;
  // Costruttore
  Nibba(float scala, float centreX, float centreY) {
    fire=loadImage("fire.png");
    esplosione = new SoundFile(NibbaGame.this, "Esplosione.mp3");
    file = new SoundFile(NibbaGame.this, "laserSound_0.mp3"); 
    isAlive=true;
    maxLife=10;
    life=0;
    collision = false;
    colpito =false;
    shotX=0;
    shotY=0;
    this.scala=scala*0.2;
    this.centreX=centreX;
    this.centreY=centreY;
  }

  // Aggiorna le variabili necessarie per l'animazione del personaggio

  void aggiornaVariabili() {
    dimPupille=4*scala;
    deltaPupilleX=(8+movPupilleX)*scala;
    deltaPupilleY=5*scala;
    dimSopraccigliaX=20*scala;
    dimSopraccigliaY=3*scala;
    deltaCentreY=20*scala;
    deltaMagliettaX=100*scala;
    deltaMagliettaY=60*scala;
    dimMagliettaX=200*scala;
    dimMagliettaY=250*scala;
    centreX=constrain(width/2+moveOr, 0, width);
    centreY=constrain(height/2+moveVer, 0, width);
    sopraccigliaY=centreY+40*scala;
    sopraccigliaX=centreX-60*scala;
    r=100*scala;
    d=2*r;
    distanzaSopracciglia=r;
    rangeMovePupi=dimSopraccigliaX/(4*scala);
  };

  // Disegna il personaggio
  public void drawNibba() { 
    if (collision) {
      if (life<maxLife)
        life++;
    }
    if (life == maxLife) {
      esplosione.play();
      dieX=centreX;
      dieY=centreY;
      centreX=-500;
      centreY=-500;
      isAlive =false;
      life++;
    }
    if (isAlive) {
      aggiornaVariabili();
      strokeWeight(3);
      stroke(0);
      fill(0, 190, 0);
      rect( centreX -2.5* r, centreY- 2*r, 5* r, - r/2);
      fill(255, 0, 0);
      rect(  centreX - 2.5* r, centreY- 2*r, 5* r*life/maxLife, - r/2);
      fill(255, 0, 0);
      rect(centreX-deltaMagliettaX, centreY+deltaMagliettaY, dimMagliettaX, dimMagliettaY);
      stroke(0, 0, 0);
      strokeWeight(5);
      fill(255);
      ellipse(centreX, centreY, d, d);
      loadPixels();
      for (int i= width*(int(centreY) -int(round(r))); i<width*(int(centreY) +int(round(r))); i++) {
        x=i%width;
        y=i/width;
        if (pow((x-centreX), 2)+pow((y-centreY), 2)<pow(r, 2) && x>0 && x<width && y>0 && y<height) {
          if (y>=centreY+deltaCentreY) {
            pixels[i]= marrone;
          } else if (y<centreY +deltaCentreY) {
            pixels[i]= nero;
          }
        }
      }
      updatePixels();
      strokeWeight(0);
      fill(0, 0, 0);
      rect(sopraccigliaX, sopraccigliaY, dimSopraccigliaX, dimSopraccigliaY);
      rect(sopraccigliaX+distanzaSopracciglia, sopraccigliaY, dimSopraccigliaX, dimSopraccigliaY);
      fill(255);
      rect(sopraccigliaX, sopraccigliaY+dimSopraccigliaY, dimSopraccigliaX, dimSopraccigliaX/2);
      rect(sopraccigliaX+distanzaSopracciglia, sopraccigliaY+dimSopraccigliaY, dimSopraccigliaX, dimSopraccigliaX/2);
      fill(0);
      rect(sopraccigliaX+deltaPupilleX, sopraccigliaY+deltaPupilleY, dimPupille, dimPupille);
      rect(sopraccigliaX+deltaPupilleX+distanzaSopracciglia, sopraccigliaY+deltaPupilleY, dimPupille, dimPupille);
      updateMovement();

      updateShooting();
    } else {
      if ( deadTime <10) {
        image(fire, dieX + r/2, dieY +r/2, 2*r*deadTime, 2*r*deadTime);
        deadTime+=0.1;
      }
      textSize(100);
      text("YOU DIED", width*1.8/5, height/2);
    }
  }

  // Gestisce il raggio laser
  private void updateShooting() {
    float x, y;
    x=mouseX- centreX;
    y=mouseY- centreY;
    if (stateTime<250) {
      x_=x/(pow(pow(x, 2)+pow(y, 2), 0.5));
      y_=y/(pow(pow(x, 2)+pow(y, 2), 0.5));
    }
    shotX=0;
    shotY=0;
    if (this.isShooting ) {
      stateTime = (millis() - startMillis)*2.0;
      if (colpito|| stateTime*x_+sopraccigliaX+deltaPupilleX > width|| stateTime*y_+ sopraccigliaY+deltaPupilleY > height ||stateTime*x_+sopraccigliaX+deltaPupilleX <0 || stateTime*y_+ sopraccigliaY+deltaPupilleY < 0) {
        this.isShooting = false;
        startMillis = 0.0f;
      } else {
        stroke(0, 0, 0);
        strokeWeight(dimPupille+0.2f);
        line(sopraccigliaX+deltaPupilleX, sopraccigliaY+deltaPupilleY, stateTime*x_+sopraccigliaX+deltaPupilleX, stateTime*y_+ sopraccigliaY+deltaPupilleY);
        line(sopraccigliaX+deltaPupilleX+distanzaSopracciglia, sopraccigliaY+deltaPupilleY, stateTime*x_ +sopraccigliaX+deltaPupilleX+distanzaSopracciglia, stateTime*y_+ sopraccigliaY+deltaPupilleY);
        stroke(255, 0, 0);
        strokeWeight(dimPupille);
        shotX = stateTime*x_ +sopraccigliaX+deltaPupilleX+distanzaSopracciglia;
        shotY = stateTime*y_+ sopraccigliaY+deltaPupilleY;
        line(sopraccigliaX+deltaPupilleX, sopraccigliaY+deltaPupilleY, stateTime*x_+sopraccigliaX+deltaPupilleX, stateTime*y_+ sopraccigliaY+deltaPupilleY);
        line(sopraccigliaX+deltaPupilleX+distanzaSopracciglia, sopraccigliaY+deltaPupilleY, shotX, shotY);
      }
    }
  }

  // Gestisce i movimenti su un ipotetico asse Z
  private void variaScalaPiu() {
    if (scala+0.1*scala<=5 && scala+0.1*scala>=0) {
      scala+=0.01*scala;
    }
  }
  private void variaScalaMeno() {
    if (scala-0.1*scala <=5 && scala-0.1*scala>=0) {
      scala-=0.01*scala;
    }
  }

  // Gestisce una variabile che diventa true mentre spariamo
  private void spara() {
    if (this.isShooting == false) {
      file.play();
      this.isShooting = true;
      startMillis = millis();
    }
    this.isShooting = true;
  };
  int boolToInt(Boolean a) {
    int b=0;
    if (a==true) {
      b=1;
    } else if (a==false) {
      b=0;
    }
    return b;
  }

  // Gestisce il movimento delle pupille
  private void muoviPupille() {
    if (dirPupille==true) {
      movPupilleX+=0.1*scala;
    } else if (dirPupille==false) {
      movPupilleX-=0.1;
    }
    if (movPupilleX>=rangeMovePupi) {
      dirPupille=false;
    }    
    if (movPupilleX<=-rangeMovePupi) {
      dirPupille=true;
    }
  }

  // Gestisce il movimento
  private void updateMovement() {
    int dirX = 0;
    int dirY = 0;
    Boolean movement=false;  
    float speed = 50.0f*scala; 
    if (scalaPiu) {
      variaScalaPiu();
      movement=true;
    }
    if (scalaMeno) {
      variaScalaMeno();
      movement=true;
    }
    if (keysPressed[KEY_LEFT]) {
      dirX = -1;
      movement= true;
    } 
    if (keysPressed[KEY_RIGHT]) {
      dirX = 1;
      movement= true;
    }
    if (keysPressed[KEY_UP]) {
      dirY = -1;
      movement= true;
    }
    if (keysPressed[KEY_DOWN]) {
      dirY = 1;
      movement= true;
    }
    moveOr += speed * dirX;
    moveVer += speed * dirY;
    moveOr=constrain(moveOr, -width/2, width/2);
    moveVer=constrain(moveVer, -height/2, height/2);
    if (!movement && !isShooting) {
      muoviPupille();
    }
  }

  // Getter e Setter
  public void setColpito(boolean colpito) {
    this.colpito=colpito;
  }
  public boolean getColpito() {
    return this.colpito;
  }
  public void setCollision(boolean collision) {
    this.collision=collision;
  }
  public float getCentreX() {
    return centreX;
  }
  public void setCentreX(float centreX) {
    this.centreX = centreX;
  }
  public float getCentreY() {
    return centreY;
  }
  public void setCentreY(float centreY) {
    this.centreY = centreY;
  }
  public float getShotX() {
    return shotX;
  }
  public void setShotX(float shotX) {
    this.shotX = shotX;
  }
  public float getShotY() {
    return shotY;
  }
  public void setShotY(float shotY) {
    this.shotY = shotY;
  }

  // Metodi orientati agli eventi
  public void keyPressed(char key) {
    if (key=='o') {
      scalaPiu=true;
    } else if (key=='i') {
      scalaMeno=true;
    } else if (key=='r' && !isAlive) {
      life=0;
      centreX=width/2;
      centreY=width/2;
      isAlive=true;
    } 
    if (key == CODED || key=='w' ||key=='s' ||key=='a'||key=='d') {
      if (keyCode == UP || key=='w' ) {
        keysPressed[KEY_UP] = true;
        keysPressed[KEY_DOWN] = false;
      } else if (keyCode == DOWN ||key=='s') {
        keysPressed[KEY_DOWN] = true;
        keysPressed[KEY_UP] = false;
      } else if (keyCode == LEFT ||key=='a') {
        keysPressed[KEY_LEFT] = true;
        keysPressed[KEY_RIGHT] = false;
      } else if (keyCode == RIGHT||key=='d') {
        keysPressed[KEY_RIGHT] = true;
        keysPressed[KEY_LEFT] = false;
      }
    }
  }
  public void keyReleased(char key) {
    if (key=='o') {
      scalaPiu=false;
    } else if (key=='i') {
      scalaMeno=false;
    }
    if (key == CODED || key=='w' ||key=='s' ||key=='a'||key=='d') {
      if (keyCode == UP|| key=='w' ) {
        keysPressed[KEY_UP] = false;
      } else if (keyCode == DOWN ||key=='s') {
        keysPressed[KEY_DOWN] = false;
      } else if (keyCode == LEFT ||key=='a') {
        keysPressed[KEY_LEFT] = false;
      } else if (keyCode == RIGHT||key=='d') {
        keysPressed[KEY_RIGHT] = false;
      }
    }
  }

  public void mouseReleased(boolean mousePressed) {
  }
  public void mousePressed(boolean mousePressed) {
    if (mousePressed) {
      spara();
    }
  }
}