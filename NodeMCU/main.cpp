#include <Arduino.h>
#include <Servo.h>          // Include Servo Library
#include <LiquidCrystal.h>  // Include LCD library

// LCD pin connections
int RS = 1;
int E  = 3;
int d4 = 12;
int d5 = 14;
int d6 = 4;
int d7 = 5;

LiquidCrystal lcd(RS, E,d4, d5, d6, d7);  // Create lcd object (pin connections)

Servo myservo;  // Create servo object

int potpin = 0;       // Analog pin used to connect the potentiometer
int val;              // Variable to read the value from the analog pin
int solenoid = 10;    // Select the pin for the solenoid
int button = 13;      // Select pin for button


void setup() {
    myservo.attach(16);          // Attaches the servo on pin 16 to the servo object
    pinMode(solenoid, OUTPUT);  // Declare the solenoid as an OUTPUT
    pinMode(button, INPUT);     // Declare the button as an INPUT

    lcd.begin(16, 2);           // Begin LCD
}

void loop() {
    val = analogRead(potpin);         // Reads the value of the potentiometer (value between 0 and 1023)
    val = map(val, 0, 1023, 0, 180);  // Scale it to use it with the servo (value between 0 and 180)
    myservo.write(val);               // Sets the servo position according to the scaled value
    delay(15);                        // Waits for the servo to get there

    lcd.clear();    // Clear LCD
    lcd.print(val); // Print angle value on LCD
    delay(15);      // Delay to reduce flickering on LCD

    // Set solenoid to the value of the button
    // - when button is pressed the solenoid is on
    digitalWrite(solenoid, digitalRead(button));
}





















////#include <Servo.h>  // add servo library
////
////Servo myservo;  // create servo object to control a servo
////
////int potpin = 0;  // analog pin used to connect the potentiometer
////int val;    // variable to read the value from the analog pin
//////int ledPin = 3;   // select the pin for the LED
////
////
////void setup() {
////    myservo.attach(14);  // attaches the servo on pin D5 to the servo object
//////  pinMode(ledPin, OUTPUT);  // declare the ledPin as an OUTPUT
////
////}
////
////void loop() {
////    val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023)
////    val = map(val, 0, 1023, 0, 180);     // scale it to use it with the servo (value between 0 and 180)
////    myservo.write(val);                  // sets the servo position according to the scaled value
//////  digitalWrite(ledPin, HIGH);  // turn the ledPin on
////    delay(15);                           // waits for the servo to get there
//////  digitalWrite(ledPin, LOW);   // turn the ledPin off
////}
//
////#include <Wire.h>  // This library is already built in to the Arduino IDE
////#include <LiquidCrystal_I2C.h> //This library you can add via Include Library > Manage Library >
////LiquidCrystal_I2C lcd(0, 16, 2);
////
////void setup()
////{
////    lcd.begin();
//////    lcd.init();   // initializing the LCD
////    lcd.backlight(); // Enable or Turn On the backlight
////    lcd.print(" Hello Makers "); // Start Printing
////}
////
////void loop()
////{
////    // Nothing Absolutely Nothing!
////}
//
//#include <LiquidCrystal_I2C.h>
//
//// Construct an LCD object and pass it the
//// I2C address, width (in characters) and
//// height (in characters). Depending on the
//// Actual device, the IC2 address may change.
//LiquidCrystal_I2C lcd(0x3F, 16, 2);
//
//void setup() {
//
//    // The begin call takes the width and height. This
//    // Should match the number provided to the constructor.
//    lcd.begin(16,2);
//    lcd.init();
//
//    // Turn on the backlight.
//    lcd.backlight();
//
//    // Move the cursor characters to the right and
//    // zero characters down (line 1).
//    lcd.setCursor(5, 0);
//
//    // Print HELLO to the screen, starting at 5,0.
//    lcd.print("HELLO");
//
//    // Move the cursor to the next line and print
//    // WORLD.
//    lcd.setCursor(5, 1);
//    lcd.print("WORLD");
//}
//
//void loop() {
//}