import processing.sound.*;
import processing.serial.*;
Serial myPort;
float prevDistance = 0;
String portName = "COM3";
String val;
PImage naveimg, asteroideimg, fondo;
SoundFile bulletSound, hitShipSound, hitAsteroidSound; 
Boolean onGame = true;
int Op1, Op2, rondas, rightAns,a, b, wrongAns = 0;
PVector navePos = new PVector(314, 385);
ArrayList<Bullet> balas;
ArrayList<Asteroide> asteroides;
ArrayList<Bullet> balasParaEliminar = new ArrayList<Bullet>();
ArrayList<Asteroide> asteroidesParaEliminar = new ArrayList<Asteroide>();
String imgURL = "./assets/img/";
String soundsURL = "./assets/sounds/";
AudioIn input;
Amplitude loudness;
 
void setup() {
  size(800,600);
  myPort = new Serial(this, portName, 9600);
  naveimg = loadImage(imgURL+"nave.png");
  asteroideimg = loadImage(imgURL+"ast0.png");
  fondo = loadImage(imgURL+"fondo.png");
  bulletSound = new SoundFile(this, soundsURL+"shoot.wav");
  hitShipSound = new SoundFile(this, soundsURL+"explosion_ship.wav");
  hitAsteroidSound = new SoundFile(this, soundsURL+"explosion_asteroid.wav");

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
    serialEvent(myPort);
      float volume = loudness.analyze();
      if (volume > 0.27){
        bulletSound.play();
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
                      if (asteroide.golpes == 3) {
                          hitAsteroidSound.play();
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
              hitShipSound.play();
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

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    float distance = float(data);
    if (distance != 0){
      float posX = distanceInPixels(distance);
       if (posX < 700) {
          navePos.set(posX, 385);
          prevDistance = distance;
      } else {
        navePos.set(distanceInPixels(prevDistance), 385);
      }
    }   
  }
}

float distanceInPixels(float distance){
  return (800/35) * distance;
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
    text("Congratulations, you survived all the rounds", 60, 300);
  }
}

void createAsteroids(int rightAns){
  asteroides.clear();
  int randomIndex = int(random(3));
  for (int i = 0; i < 3; i++) {
    if (i == randomIndex){
      float x = (i * 50) + (i * 210);
      float y = -200;
      asteroides.add(new Asteroide(x, y, asteroideimg, rightAns, 0));      
    }
    else {
      do {  
        wrongAns = int(random(40));
      } while (wrongAns == rightAns);
      float x = (i * 50) + (i * 210);
      float y = -200;
      asteroides.add(new Asteroide(x, y, asteroideimg, wrongAns, 0));
      
    }
  }
}

void selectRound(){
  a = int(random(20));
  b = int(random(20));
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
  balas.clear();
  onGame = true;
  selectRound();
}

// Descomentar esta funcion para usar las flechas del teclado.
void keyPressed(){
  if(key == CODED){
    if (keyCode == UP){
        bulletSound.play();
        Bullet nuevaBala = new Bullet(navePos.x + 50, navePos.y, loadImage(imgURL+"bullet.png"));
        balas.add(nuevaBala);
    }
    if (keyCode == RIGHT && navePos.x + 10 < 650) {
      navePos.add(20, 0);
    }
    if (keyCode == LEFT && navePos.x - 10 > 0) {
      navePos.sub(20, 0);
    } 
  }
}
