#include <Servo.h>          // Include Servo Library
#include <LiquidCrystal.h>  // Include LCD library

// LCD pin connections
int RS = 7;
int E  = 6;
int d4 = 5;
int d5 = 4;
int d6 = 3;
int d7 = 2;

LiquidCrystal lcd(RS, E, d4, d5, d6, d7);  // Create lcd object (pin connections)
//LiquidCrystal lcd(7, 6, 5, 4, 3, 2);  // Create lcd object (2-7 = pin connections)
 
Servo myservo;  // Create servo object
 
int potpin = 0;       // Analog pin used to connect the potentiometer
int val;              // Variable to read the value from the analog pin
int solenoid = 10;    // Select the pin for the solenoid
int button = 9;       // Select pin for button

 
void setup() {
  myservo.attach(8);          // Attaches the servo on pin 8 to the servo object
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
