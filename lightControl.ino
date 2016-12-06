
int leds[3] = {D0, D1, D2};
int states[3] = {LOW, LOW, LOW};
int totalDevices = 3;


void setup() {

  Serial.begin(9600);
  
  setupPinsMode();

}

void loop() {


  for(int i = 0; i < totalDevices; i++){
    Serial.printf("Turn on led %d", i);
    turnOnLed(leds[i]);
    delay(2000);
  }

// turn those leds off.

  for(int j = 0; j < totalDevices; j++){
    Serial.printf("Turn Off led %d", j);
    turnOffLed(leds[j]);
    delay(2000);
  }
  


}


void setupPinsMode() {

  // setup Pin mode as output.


  for(int i; i< totalDevices; i++){

    Serial.printf("Setup Output for pin %d",leds[i]);
    pinMode(leds[i], OUTPUT);
  }

}

void turnOnLed(int pin) {

  digitalWrite(pin, HIGH);

}

void turnOffLed(int pin) {

  digitalWrite(pin, LOW);
}

