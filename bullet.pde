class Bullet {
  PImage imagen;
  float posX, posY;
  
  Bullet(float x, float y, PImage img) {
    this.posX = x;
    this.posY = y;
    this.imagen = img;
  }
  
  void mover() {
    this.posY -= 10;
  }
  
  float getX() {
    return this.posX;
  }
  
  float getY() {
    return this.posY;
  }
  
  void mostrar() {
    image(this.imagen, this.posX, this.posY, 50, 50);
  }
  
  boolean fueraDePantalla() {
    return this.posY < 0;
  }
}
