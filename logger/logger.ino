#include <Arduino.h>
#include <math.h>
#define SQUARE_WAVE 0

// Create an IntervalTimer object 
IntervalTimer myLogger;
IntervalTimer myControlLoop;
const    int controlPeriod  = 1000; //in micro seconds 1000 => 1kHz
volatile long N_sample      = 0;// then number of samples
volatile long N_control     = 0;//control loop counts
volatile int phase          = 0;
volatile int N_phase;             // the number of control interupts per phase
volatile float frequency    = .1; //hz
const    int Pmax           = 200; // this is the level that corresponds to about 30 psi

#define K_P   10

  
int pressure; // the value of the sensor
float   pressureCommanded;
float   pressureError;
const int ledPin = LED_BUILTIN;  // the pin with a LED
const int pressurePin = 9;
const int fluidIn  = 2;
const int fluidOut = 3;
volatile int fluidInVoltage;
volatile int fluidOutVoltage;

// The interrupt will blink the LED, and keep
// track of how many times it has blinked.
int ledState = LOW;
volatile unsigned long blinkCount = 0; // use volatile for shared variables

// functions called by IntervalTimer should be short, run as quickly as

void ControlLoop(){
  N_control = N_control + 1;
  phase = N_control % N_phase;
  pressure = analogRead(pressurePin);
  pressureCommanded = Pmax*sin(float(phase)/float(N_phase)*2.0*PI)+291;
  pressureError     = pressureCommanded-pressure;

  if(pressureError > 0){
    fluidInVoltage = pressureError*K_P;
    if(fluidInVoltage > 250){fluidInVoltage = 250;}
    fluidOutVoltage =  0;
    analogWrite(fluidIn, fluidInVoltage);
    analogWrite(fluidOut,fluidOutVoltage)  ;

  }
  else{
    fluidInVoltage = 0;
    fluidOutVoltage = abs(pressureError)*K_P;
    if(fluidOutVoltage > 250){fluidOutVoltage = 250;}
    analogWrite(fluidIn, fluidInVoltage);
    analogWrite(fluidOut,fluidOutVoltage)  ;


  }



  
  //pressureError = pressureCommanded-pressure;
  if (SQUARE_WAVE){
  if (phase < N_phase/2){ //fill
    fluidInVoltage = 250;
    fluidOutVoltage =  0;
    analogWrite(fluidIn, fluidInVoltage);
    analogWrite(fluidOut,fluidOutVoltage)  ;
  }
  else{            //empty
    fluidInVoltage =    0;
    fluidOutVoltage = 250;
    analogWrite(fluidIn, fluidInVoltage);
    analogWrite(fluidOut,fluidOutVoltage);
  }
    }

}
  
// possible, and should avoid calling other functions if possible.
void writeData() {
    N_sample = N_sample + 1;
    Serial.print(fluidInVoltage)   ;Serial.print(",");
    Serial.print(fluidOutVoltage)  ;Serial.print(",");    
    Serial.print(pressureCommanded);Serial.print(",");
    Serial.print(pressureError)    ;Serial.print(",");
    Serial.println(pressure);
}

void setup() {
  pinMode(ledPin,   OUTPUT);
  pinMode(fluidIn,  OUTPUT);
  pinMode(fluidOut, OUTPUT);
  pinMode(pressurePin,INPUT);
  Serial.begin(9600);
  myLogger.begin(writeData,          10000);  // writeData to run every 0.01 seconds
  myControlLoop.begin(ControlLoop,  controlPeriod); // control every second
  N_phase = 1e6/controlPeriod/frequency;
  Serial.println(N_phase);
  
}



// The main program will print the blink count
// to the Arduino Serial Monitor
void loop() {
 
}
