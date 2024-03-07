PImage naveimg, asteroideimg, fondo;
Boolean onGame = true;
int Op1, Op2, rondas, rightAns,a, b, wrongAns = 0;
PVector navePos = new PVector(314, 385);
ArrayList<Bullet> balas;
ArrayList<Asteroide> asteroides;
ArrayList<Bullet> balasParaEliminar = new ArrayList<Bullet>();
ArrayList<Asteroide> asteroidesParaEliminar = new ArrayList<Asteroide>();
String imgURL = "./assets/img/";
import processing.sound.*;
AudioIn input;
Amplitude loudness;
 
void setup() {
  size(800,600);
  naveimg = loadImage(imgURL+"nave.png");
  asteroideimg = loadImage(imgURL+"ast0.png");
  fondo = loadImage(imgURL+"fondo.png");
  balas = new ArrayList<Bullet>();
  asteroides = new ArrayList<Asteroide>();
  startGame();
  input = new AudioIn(this, 0);

  input.start();
  loudness = new Amplitude(this);

  loudness.input(input);
}

void draw() {
  
 background(fondo);
  
  if (onGame) {
      float inputLevel = map(mouseY, 0, height, 1.0, 0.0);
      input.amp(inputLevel);
      float volume = loudness.analyze();
      if (volume > 0.1){
        Bullet nuevaBala = new Bullet(navePos.x + 50, navePos.y, loadImage(imgURL+"bullet.png"));
        balas.add(nuevaBala);

      }

      for (Bullet bala : balas) {
          bala.mover();
          bala.mostrar();
  
          for (Asteroide asteroide : asteroides) {
              if (asteroide.hitbullet(bala.getX(), bala.getY())) {
                  balasParaEliminar.add(bala);
                  if (asteroide.getValue() == rightAns) {
                      asteroide.hit();
                      if (asteroide.golpes == 4) {
                          asteroidesParaEliminar.add(asteroide);
                      }
                  } else {
                      for (Asteroide ast : asteroides) {
                          ast.increaseSpeed();
                      }
                  }
                  break;
              }
          }
      }
  
      balas.removeAll(balasParaEliminar);
      asteroides.removeAll(asteroidesParaEliminar);
  
      for (Asteroide asteroide : asteroides) {
          asteroide.mover();
          asteroide.mostrar();
          if (asteroide.hitship(navePos)) {
              onGame = false;
          }
          if (asteroide.fueraDePantalla()) {
              rondas += 1;
              startGame();
              break; 
          }
      }
           
   image(naveimg,navePos.x,navePos.y,155,114);
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

void showOperation(int a, int b, String sign){
  textSize(50);
  fill(255,255,255);
  text(a + sign + b , 340, 560);
}

void showRound(){
  if (rondas >= 0 && rondas <= 2){
    showOperation(a, b, " + ");
  } else if (rondas >= 3 && rondas <= 5){
    showOperation(a, b, " - ");
  } else if (rondas >= 6 && rondas <= 8){
    showOperation(a, b, " x ");
  } else {
    navePos.y -= 2;
    textSize(40);
    fill(255,255,0);
    text("Felicidades, sobreviviste todas las rondas", 60, 300);
  }
}

void createAsteroids(int rightAns){
  asteroides.clear();
  int randomIndex = int(random(6));
  for (int i = 0; i < 6; i++) {
    if (i == randomIndex){
      float x = (i * 95) + (i * 40);
      float y = -100;
      asteroides.add(new Asteroide(x, y, asteroideimg, rightAns, 0));      
    }
    else {
      do {  
        wrongAns = int(random(20));
      } while (wrongAns == rightAns);
      float x = (i * 95) + (i * 40);
      float y = -100;
      asteroides.add(new Asteroide(x, y, asteroideimg, wrongAns, 0));
      
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
    if (keyCode == RIGHT && navePos.x + 10 < 650) {
      navePos.add(20, 0);
    }
    if (keyCode == LEFT && navePos.x - 10 > 0) {
      navePos.sub(20, 0);
    } 
  }
}
