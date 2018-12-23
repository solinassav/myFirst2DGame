import processing.sound.*;
public class Grinch extends Enemies {
  public Grinch(float scala){
    super(scala,"Esplosione.mp3","grinch.png","grinchvivo.png","fire.png");
    setDimX(500);
    setDimY(300);
    setVel(10);
    setTempoCambioDirezione(200);
    setMaxLife(5);
  }
}