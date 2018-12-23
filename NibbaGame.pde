LevelOne level =new LevelOne
();

void keyPressed() {
  level.keyPressed();
}
void mousePressed() {
  level.mousePressed();
}
void mouseReleased() {
  level.mousePressed();
}
void keyReleased() {
  level.keyReleased();
}
void setup() {
  fullScreen();
  level.setup();
}
void draw() {
  level.draw();
}