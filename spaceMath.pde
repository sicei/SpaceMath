import processing.sound.*;
import processing.serial.*;

Serial myPort;
float prevDistance = 0;
String portName = "COM3";
String val;
PImage naveimg, asteroideimg, fondo;
SoundFile bulletSound, hitShipSound, hitAsteroidSound; 
Boolean onGame = true;
int Op1, Op2, rondas, rightAns, a, b, wrongAns = 0;
PVector navePos = new PVector(314, 385);
ArrayList<Bullet> balas;
ArrayList<Asteroide> asteroides;
ArrayList<Bullet> balasParaEliminar = new ArrayList<Bullet>();
ArrayList<Asteroide> asteroidesParaEliminar = new ArrayList<Asteroide>();
String imgURL = "./assets/img/";
String soundsURL = "./assets/sounds/";
AudioIn input;
Amplitude loudness;

// Variables para la selección de dificultad
int dificultad = 0; // 0: No seleccionada, 1: Fácil, 2: Normal, 3: Difícil
boolean seleccionandoDificultad = true;

void setup() {
  size(800, 600);
  myPort = new Serial(this, portName, 9600);
  naveimg = loadImage(imgURL + "nave.png");
  asteroideimg = loadImage(imgURL + "ast0.png");
  fondo = loadImage(imgURL + "fondo.png");
  bulletSound = new SoundFile(this, soundsURL + "shoot.wav");
  hitShipSound = new SoundFile(this, soundsURL + "explosion_ship.wav");
  hitAsteroidSound = new SoundFile(this, soundsURL + "explosion_asteroid.wav");

  balas = new ArrayList<Bullet>();
  asteroides = new ArrayList<Asteroide>();
  input = new AudioIn(this, 0);
  input.start();
  loudness = new Amplitude(this);
  loudness.input(input);
}

void draw() {
  background(fondo);
  
  if (seleccionandoDificultad) {
    mostrarMenuDificultad();
  } 
  else if (onGame) {
    float volume = loudness.analyze();
    fill(255);
    textSize(16);
    text("Volumen detectado: " + nf(volume, 1, 3), 10, 20);

    // Mostrar en consola
    println("Volumen: " + volume);
    if (volume > 0.01) {
      bulletSound.play();
      Bullet nuevaBala = new Bullet(navePos.x + 50, navePos.y, loadImage(imgURL + "bullet.png"));
      balas.add(nuevaBala);
    }

    // --- Agrega esta condición para desactivar la lógica del juego al ganar ---
    if (rondas <= 8) {  // Solo procesa balas/asteroides si no ha ganado
      serialEvent(myPort);
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
    }
  image(naveimg, navePos.x, navePos.y, 155, 114);
  showRound();

    
}
  else {
    textSize(70);
    text("Has Sobrevivido " + rondas + " Rondas", 30, 300);
    fill(255, 0, 0);
    textSize(70);
    text("¡Perdiste!", 270, 230);
    textSize(30);
    text("Presiona R Para Jugar", 270, 370);
    text("Nuevamente", 320, 400);
    if (keyPressed) {
      if (key == 'R' || key == 'r') {
        rondas = 0;
        startGame();
      }
    }
  }
}

void mostrarMenuDificultad() {
  textSize(70);
  fill(255, 255, 0);
  text("Selecciona La Dificultad", 60, 150);
  
  textSize(40);
  fill(dificultad == 1 ? color(0, 255, 0) : color(255));
  text("Fácil (0-10)", 300, 250);
  
  fill(dificultad == 2 ? color(0, 255, 0) : color(255));
  text("Normal (10-20)", 270, 300);
  
  fill(dificultad == 3 ? color(0, 255, 0) : color(255));
  text("Difícil (20-40)", 280, 350);
  
  textSize(30);
  fill(255);
  text("Presiona 1, 2 ó 3 para elegir", 230, 450);
}

void serialEvent(Serial myPort) {
  if (rondas <= 8) {  // Solo actualizar posición normalmente si el juego está en progreso
    String data = myPort.readStringUntil('\n');
    if (data != null) {
      data = trim(data);
      float distance = float(data);
      if (distance != 0) {
        float posX = distanceInPixels(distance);
        if (posX < 700) {
          navePos.set(posX, 385);  // Mantener Y=385 durante el juego
          prevDistance = distance;
        } else {
          navePos.set(distanceInPixels(prevDistance), 385);
        }
      }
    }
  }
  else {
    navePos.y -= 0.9;  // Velocidad de ascenso al finalizar el juego
    if (navePos.y < -200) {
      navePos.y = -200;  // Límite superior
    }
    
    String data = myPort.readStringUntil('\n');
    if (data != null) {
      data = trim(data);
      float distance = float(data);
      if (distance != 0) {
        float posX = distanceInPixels(distance);
        if (posX < 700) {
          navePos.x = posX;
          prevDistance = distance;
        } else {
          navePos.x = distanceInPixels(prevDistance);
        }
      }
    }
  }
}

float distanceInPixels(float distance) {
  return (800 / 35) * distance;
}

void showOperation(int a, int b, String sign) {
  textSize(50);
  fill(255, 255, 255);
  text(a + sign + b, 340, 560);
}

void showRound() {
  if (rondas >= 0 && rondas <= 2) {
    showOperation(a, b, " + ");
  } else if (rondas >= 3 && rondas <= 5) {
    showOperation(a, b, " - ");
  } else if (rondas >= 6 && rondas <= 8) {
    showOperation(a, b, " x ");
  } else if (rondas > 8) {
    textSize(40);
    fill(255, 255, 0);
    text("¡Felicidades! Has superado todas las rondas", 40, 300);
  }
}

// Función que genera dos respuestas incorrectas
int[] getWrongAnswers(int n) {
  return new int[] { n - 1, n + 1 };
}

// Función que crea los asteroides con una respuesta correcta y dos incorrectas
void createAsteroids(int rightAns) {
  asteroides.clear();
  int randomIndex = int(random(3)); // Índice aleatorio para el asteroide correcto

  // Obtener valores incorrectos usando ±1
  int[] wrongs = getWrongAnswers(rightAns);
  int wrongAns1 = wrongs[0];
  int wrongAns2 = wrongs[1];

  // Crear 3 asteroides
  for (int i = 0; i < 3; i++) {
    float x = (i * 50) + (i * 210);
    float y = -200;

    if (i == randomIndex) {
      asteroides.add(new Asteroide(x, y, asteroideimg, rightAns, 0)); // Correcto
    } else if ((i + 3 - randomIndex) % 3 == 1) {
      asteroides.add(new Asteroide(x, y, asteroideimg, wrongAns1, 0)); // Incorrecto 1
    } else {
      asteroides.add(new Asteroide(x, y, asteroideimg, wrongAns2, 0)); // Incorrecto 2
    }
  }
}



void selectRound() {
  int min, max;
  
  // Define rangos según dificultad
  switch (dificultad) {
    case 1: // Fácil
      min = 0;
      max = 10;
      break;
    case 2: // Normal
      min = 10;
      max = 20;
      break;
    case 3: // Difícil
      min = 20;
      max = 40;
      break;
    default: // Por defecto (Normal)
      min = 10;
      max = 20;
  }
  
  a = int(random(min, max));
  b = int(random(min, max));
  
  Operacion operacion = new Operacion(a, b);
  if (rondas >= 0 && rondas <= 2) {
    rightAns = operacion.suma();
    println(a + " + " + b + " = " + rightAns);
  } else if (rondas >= 3 && rondas <= 5) {
    rightAns = operacion.resta();
    println(a + " - " + b + " = " + rightAns);
  } else if (rondas >= 6 && rondas <= 8) {
    rightAns = operacion.multiplicacion();
    println(a + " * " + b + " = " + rightAns);
  }
  
  createAsteroids(rightAns);
}

void startGame() {
  if (!onGame) {
    seleccionandoDificultad = true; // Volver a mostrar el menú al perder
  }
  fill(255, 255, 255);
  balas.clear();
  onGame = true;
  selectRound();
}

void keyPressed() {
  if (seleccionandoDificultad) {
    if (key == '1') {
      dificultad = 1;
      seleccionandoDificultad = false;
      startGame();
    } else if (key == '2') {
      dificultad = 2;
      seleccionandoDificultad = false;
      startGame();
    } else if (key == '3') {
      dificultad = 3;
      seleccionandoDificultad = false;
      startGame();
    }
  } else if (key == CODED) {
    if (keyCode == UP) {
      bulletSound.play();
      Bullet nuevaBala = new Bullet(navePos.x + 50, navePos.y, loadImage(imgURL + "bullet.png"));
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
