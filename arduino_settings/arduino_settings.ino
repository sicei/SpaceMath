#define TRIGGER_PIN 12
#define ECHO_PIN 11
#define MIN_DISTANCE_CM 0
#define MAX_DISTANCE_CM 35
#define OFFSET_DISTANCE_CM 5

void setup() {
  Serial.begin(9600);
  pinMode(TRIGGER_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void loop() {
  long duration, distance;
  
  digitalWrite(TRIGGER_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER_PIN, LOW);
  
  duration = pulseIn(ECHO_PIN, HIGH);
  
  distance = duration * 0.034 / 2;
  
  if (distance >= MIN_DISTANCE_CM && distance <= MAX_DISTANCE_CM) {
    if (distance <= OFFSET_DISTANCE_CM) {
      distance = 0;
    } else {
      distance -= OFFSET_DISTANCE_CM;
    }
  } else {
    distance = 0;
  }

  Serial.println(distance);
  
  delay(50);
}
