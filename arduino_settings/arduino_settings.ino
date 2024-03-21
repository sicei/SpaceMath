#define TRIGGER_PIN 12
#define ECHO_PIN 11
#define MIN_DISTANCE_CM 0
#define MAX_DISTANCE_CM 45
#define OFFSET_DISTANCE_CM 10

void setup() {
  Serial.begin(9600);
  pinMode(TRIGGER_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void loop() {
  long duration;
  float distance;
  
  digitalWrite(TRIGGER_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER_PIN, LOW);
  
  duration = pulseIn(ECHO_PIN, HIGH);
  
  distance = duration * 0.034;
  
  if (distance >= MIN_DISTANCE_CM && distance <= MAX_DISTANCE_CM) {
    if (distance <= OFFSET_DISTANCE_CM) {
      distance = 0;
    } else {
      distance -= OFFSET_DISTANCE_CM;
    }
  } else {
    distance = 0;
  }

  Serial.println(distance, 2); // Imprime la distancia con 1 decimal
  
  delay(50);
  delay(50); 
}
