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
    if (this.golpes < 3) {
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
    image(this.imagen, this.posX, this.posY, 270, 270);
    textSize(90);
    fill(0,0,0);
    if (this.value < 9){
      text(str(value), this.posX + 110, this.posY + 160);
    } else { 
      text(str(value), this.posX + 90, this.posY + 160);    
    }  
  }
  
  boolean fueraDePantalla() {
    return this.posY > height + 100;
  }
  
  boolean hitbullet(float posXbullet, float posYbullet) {
    if (posXbullet >= this.posX &&
        posXbullet <= this.posX + 210 &&
        posYbullet >= this.posY &&
        posYbullet <= this.posY + 210) {
          return true;
        
        } else{
          return false;
        }
  }
  
  boolean hitship(PVector navePos) {
      if (navePos.x >= this.posX &&
          navePos.x <= this.posX + 250 &&
          navePos.y >= this.posY &&
          navePos.y <= this.posY + 230) {
            return true;
      } else {
            return false;
      }
  }

}
