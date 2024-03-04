class Asteroide {
  PImage imagen;
  float posX, posY;
  boolean enMovimiento = true;
  int value;
  int speed = 1;
  
  Asteroide(float x, float y, PImage img, int ans) {
    this.posX = x;
    this.posY = y;
    this.imagen = img;
    this.value = ans;
  }
  
  void mover() {
    if (enMovimiento){
      this.posY += speed;
    }
  }
  
  void increaseSpeed(){
  
    speed += 1;
  
  }
  
  int getValue(){
  
    return this.value;
  
  }
  
  void mostrar() {
    image(this.imagen, this.posX, this.posY, 100, 100);
    textSize(30);
    text(str(value), this.posX + 30, this.posY - 20);
  }
  
  void stop() {
    enMovimiento = false;
  }
  
  boolean fueraDePantalla() {
    return this.posY > height + 100;
  }
  
  boolean hitbullet(float posXbullet, float posYbullet) {
      float asteroidWidth = 100;
      float asteroidHeight = 100;
  
      if ((this.posX > posXbullet - asteroidWidth / 2  && this.posX < posXbullet + asteroidWidth / 2 ) && 
          (this.posY >= posYbullet - asteroidHeight / 2 ) && 
          (this.posY <= posYbullet + asteroidHeight / 2)) {
          return true;
      }
      return false;
  }
  
  boolean hitship(float posXnave) {
      float shipWidth = 155;
      float shipHeight = 114;
  
      if ((this.posX > posXnave - shipWidth / 2  && this.posX < posXnave + shipWidth / 2 ) && 
          (this.posY >= posYnave - shipHeight / 2 ) && 
          (this.posY <= posYnave + shipHeight / 2 )) {
          return true;
      }
      return false;
  }
}
