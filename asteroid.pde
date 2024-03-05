class Asteroide {
  PImage imagen;
  float posX, posY;
  boolean enMovimiento = true;
  int value, golpes;
  float speed = 1.5;
  
  Asteroide(float x, float y, PImage img, int ans, int golpes) {
    this.posX = x;
    this.posY = y;
    this.imagen = img;
    this.value = ans;
    this.golpes = golpes;
  }
  
  void hit(){
    if (this.golpes < 5) {
      this.posX += random(-2,2);
      this.posY += random(-25,0);
      this.golpes += 1;
    }
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
  
  boolean hitship(PVector navePos) {
      float shipWidth = 155;
      float shipHeight = 114;
  
      if ((this.posX > navePos.x - shipWidth / 2 && this.posX < navePos.x + shipWidth / 2) && 
          (this.posY >= navePos.y - shipHeight / 2) && 
          (this.posY <= navePos.y + shipHeight / 2)) {
          return true;
      }
      return false;
  }
}
