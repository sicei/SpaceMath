#define TRIGGER_PIN 12
#define ECHO_PIN 11
#define MAX_DISTANCE_CM 30 

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
  
  if (distance <= MAX_DISTANCE_CM) {
    Serial.println(distance);
  } else {
    Serial.println(0);
  }
  
  delay(200); 
}
