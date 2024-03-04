PImage nave, asteroide, fondo;
Boolean GenNum = true;
Boolean onGame = true;
int Op1, Op2, rondas, rightAns,a, b = 0;
int PosXnave =314;
int posYnave = 385;
Asteroide[] asteroides;
 
void setup() {
  size(800,600);
  nave = loadImage("nave.png");
  asteroide = loadImage("ast0.png");
  fondo = loadImage("fondo.jpg");
  startGame();
}

int suma(int a, int b){
  return a + b;
}

ArrayList<Bullet> balas = new ArrayList<Bullet>();

Asteroide[] eliminarAsteroide(Asteroide[] array, int indice) {
  Asteroide[] nuevoArray = new Asteroide[array.length - 1];
  System.arraycopy(array, 0, nuevoArray, 0, indice);
  System.arraycopy(array, indice + 1, nuevoArray, indice, array.length - indice - 1);
  return nuevoArray;
}

void draw() {
  
 background(fondo);
  
 if (onGame) {   
    for (int i = balas.size() - 1; i >= 0; i--) {
        Bullet bala = balas.get(i);
        bala.mover();
        bala.mostrar();
    
        for (int j = asteroides.length - 1; j >= 0; j--) {
    
            if (asteroides[j].hitbullet(bala.getX(), bala.getY())) {
                balas.remove(i);
                if (asteroides[j].getValue() == rightAns){
      
                  asteroides = eliminarAsteroide(asteroides, j);

                }
                else {
                  
                  for (int k = 0; k < asteroides.length; k++) {
                        asteroides[k].increaseSpeed();
                  }                
                }
                break;
            }
        }
    
        if (!balas.isEmpty()) {
            for (int z = balas.size() - 1; z >= 0; z--) {
                if (balas.get(z).fueraDePantalla()) {
                    balas.remove(z);
                }
            }
        }
    }
    
    for (int i = asteroides.length - 1; i >= 0; i--) {
        asteroides[i].mover();
        asteroides[i].mostrar();
        if (asteroides[i].hitship(PosXnave)){
            onGame = false;
        }
        
        if (asteroides[i].fueraDePantalla()){
            rondas += 1;
            startGame();
        }
    }

   // top-up == 0, top-botom == 650
   // rigth-top == 800, left-top == 0
   image(nave,PosXnave,posYnave,155,114);
   textSize(50);
   text(a + " + " + b , 330, 560);
 }
 else {
   textSize(70);
   text("You Survived " + rondas + " Rounds", 60, 300);
   fill(255,0,0);
   textSize(70);
   text("You Lose", 270, 230);
   textSize(30);
   text("Press R To Retry", 270, 370);
   if (keyPressed){
     
     if (key == 'R' || key == 'r') {
       rondas = 0;
       startGame();
     }
   }
 }
}

void startGame() {
  fill(255,255,255);
  onGame = true;
  balas.clear();
  asteroides = new Asteroide[6];
  int randomIndex = int(random(asteroides.length - 1));
  a = int(random(100));
  b = int(random(100));
  rightAns = suma(a, b);
  println("a: " + a + " b: " + b +" ans: "+rightAns);
  for (int i = 0; i < asteroides.length; i++) {
    if (i == randomIndex){
      float x = (i * 100) + (i * 40);
      float y = -100;
      asteroides[i] = new Asteroide(x, y, asteroide, rightAns);      
    }
    else {
      
      float x = (i * 100) + (i * 40);
      float y = -100;
      asteroides[i] = new Asteroide(x, y, asteroide, int(random(100)));
    }
  }
}


void keyPressed(){
  if(key == CODED){
    if (keyCode == UP) {
      Bullet nuevaBala = new Bullet(PosXnave + 50, posYnave, loadImage("bullet.png"));
      balas.add(nuevaBala);
    }
    if(keyCode == RIGHT){
      if(PosXnave + 10 < 650){
        PosXnave+=20;
      }
    }
    if(keyCode == LEFT){
      if (PosXnave - 10 > 0){
        PosXnave-=20;
      }
    }  
  }
}
