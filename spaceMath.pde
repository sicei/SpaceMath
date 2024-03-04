PImage nave, asteroide, fondo;
Boolean GenNum = true;
Boolean onGame = true;
Boolean win = false;
int Op1, Op2, rondas, rightAns,a, b, wrongAns = 0;
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
                  asteroides[j].hit();
                  if (asteroides[j].golpes == 4){
                    asteroides = eliminarAsteroide(asteroides, j);
                  }                  
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
    
   image(nave,PosXnave,posYnave,155,114);
   showRound();

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

void showRound(){
  if (rondas >= 0 && rondas <= 2){
     textSize(50);
     text(a + " + " + b , 330, 560);    
  } else if (rondas >= 3 && rondas <= 5){
     textSize(50);
     text(a + " - " + b , 330, 560);   
  } else if (rondas >= 6 && rondas <= 8){
     textSize(50);
     text(a + " x " + b , 330, 560);  
  } else {
    posYnave -= 5;
    textSize(40);
    fill(255,255,0);
    text("Felicidades, sobreviviste todas las rondas", 60, 300);
  }
}

void createAsteroids(int rightAns){
  
  asteroides = new Asteroide[6];
  int randomIndex = int(random(asteroides.length - 1));
  for (int i = 0; i < asteroides.length; i++) {
    if (i == randomIndex){
      float x = (i * 100) + (i * 40);
      float y = -100;
      asteroides[i] = new Asteroide(x, y, asteroide, rightAns, 0);      
    }
    else {
      do {  
        wrongAns = int(random(20));
      } while (wrongAns == rightAns);
      float x = (i * 100) + (i * 40);
      float y = -100;
      asteroides[i] = new Asteroide(x, y, asteroide, int(random(20)), 0);
      
    }
  }
}

void selectRound(){
  a = int(random(10));
  b = int(random(10));
  Operacion operacion = new Operacion(a, b);
  if (rondas >= 0 && rondas <= 2){
    rightAns = operacion.suma();
    createAsteroids(rightAns); 
    println(a + " + " + b + " = " +rightAns);
  } else if (rondas >= 3 && rondas <= 5) {
    rightAns = operacion.resta();
    createAsteroids(rightAns); 
    println(a + " -" + b + " = " +rightAns);
  } else if (rondas >= 6 && rondas <= 8){
    rightAns = operacion.multiplicacion();
    createAsteroids(rightAns); 
    println(a + " * " + b + " = " +rightAns); 
  }
  
}

void startGame() {
  fill(255,255,255);
  onGame = true;
  balas.clear();
  selectRound();
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
