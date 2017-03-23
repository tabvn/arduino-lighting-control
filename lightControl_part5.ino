#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>



int leds[3] = {D0, D1, D2};
int states[3] = {LOW, LOW, LOW};
int totalDevices = 3;


#define firebaseURl "lightcontrol-65853.firebaseio.com"
#define authCode "0evGlpa6nMCeVYZTIDus6xDebtS50b4uCS0atqJQ"

#define wifiName "Home"
#define wifiPass "hoaminh8vn"


String chipId = "123";


#define DEBOUNCE 10
byte buttons[] = {D4, D5, D6};
#define NUMBUTTONS sizeof(buttons)
byte pressed[NUMBUTTONS], justpressed[NUMBUTTONS], justreleased[NUMBUTTONS];
byte previous_keystate[NUMBUTTONS], current_keystate[NUMBUTTONS];

void setupFirebase() {

  Firebase.begin(firebaseURl, authCode);
}

void setupWifi() {

  WiFi.begin(wifiName, wifiPass);

  Serial.println("Hey i 'm connecting...");

  while (WiFi.status() != WL_CONNECTED) {

    Serial.println(".");
    delay(500);
  }

  Serial.println();
  Serial.println("I 'm connected and my IP address: ");
  Serial.println(WiFi.localIP());
}


void setup() {

  Serial.begin(9600);

  setupWifi();
  setupFirebase();

  setupLeds();

  setupButtons();

}



void getData() {

  String path = chipId + "/states";
  FirebaseObject object = Firebase.get(path);

  bool led1 = object.getBool("001");
  bool led2 = object.getBool("002");
  bool led3 = object.getBool("003");


  // write output high or low to turn on or off led
  digitalWrite(leds[0], led1);

  digitalWrite(leds[1], led2);

  digitalWrite(leds[2], led3);

}
void loop() {


  getData();



  byte ledIndex = thisSwitch_justPressed();
  String devicePath;

  switch (ledIndex)
  {
    case 0:
      devicePath = chipId + "/states/001";

      doOnOffLed(ledIndex, devicePath);

      break;
    case 1:
      devicePath = chipId + "/states/002";
      doOnOffLed(ledIndex, devicePath);
      break;
    case 2:
      devicePath = chipId + "/states/003";
      doOnOffLed(ledIndex, devicePath);
      break;
  }

}

void doOnOffLed(int index, String path) {


  int state = !states[leds[index]];
  states[leds[index]] = state;
  digitalWrite(leds[index], state);


  // send to firebase server

  Firebase.setBool(path, state);

}

void setupLeds() {

  // setup Pin mode as output.


  for (int i; i < totalDevices; i++) {

    Serial.printf("Setup Output for pin %d", leds[i]);
    pinMode(leds[i], OUTPUT);
  }
}

void setupButtons() {


  byte i;

  // Make input & enable pull-up resistors on switch pins
  for (i = 0; i < NUMBUTTONS; i++) {
    pinMode(buttons[i], INPUT);
    digitalWrite(buttons[i], HIGH);
  }
}

void check_switches()
{
  static byte previousstate[NUMBUTTONS];
  static byte currentstate[NUMBUTTONS];
  static long lasttime;
  byte index;
  if (millis() < lasttime) {
    // we wrapped around, lets just try again
    lasttime = millis();
  }
  if ((lasttime + DEBOUNCE) > millis()) {
    // not enough time has passed to debounce
    return;
  }
  // ok we have waited DEBOUNCE milliseconds, lets reset the timer
  lasttime = millis();
  for (index = 0; index < NUMBUTTONS; index++) {
    justpressed[index] = 0;       //when we start, we clear out the "just" indicators
    justreleased[index] = 0;
    currentstate[index] = digitalRead(buttons[index]);   //read the button
    if (currentstate[index] == previousstate[index]) {
      if ((pressed[index] == LOW) && (currentstate[index] == LOW)) {
        // just pressed
        justpressed[index] = 1;
      }
      else if ((pressed[index] == HIGH) && (currentstate[index] == HIGH)) {
        justreleased[index] = 1; // just released
      }
      pressed[index] = !currentstate[index];  //remember, digital HIGH means NOT pressed
    }
    previousstate[index] = currentstate[index]; //keep a running tally of the buttons
  }
}


byte thisSwitch_justPressed() {
  byte thisSwitch = 255;
  check_switches();  //check the switches &amp; get the current state
  for (byte i = 0; i < NUMBUTTONS; i++) {
    current_keystate[i] = justpressed[i];
    if (current_keystate[i] != previous_keystate[i]) {
      if (current_keystate[i]) thisSwitch = i;
    }
    previous_keystate[i] = current_keystate[i];
  }
  return thisSwitch;
}


