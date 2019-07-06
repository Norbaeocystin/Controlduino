#include <Wire.h>

#define SLAVE_ADDRESS 0x60
#define MIN_PIN A0
#define MAX_PIN A5

int number = 0;
unsigned int light = 0;
// maximal value for analogs is from 0 to 1023  10 bits

void setup() {
    Serial.begin(9600); // start serial for output
    // initialize i2c as slave
    Wire.begin(SLAVE_ADDRESS);

    // define callbacks for i2c communication
    Wire.onReceive(receiveData);
    Wire.onRequest(sendData);
}

void loop() {
    delay(10);
}

// callback for received data
void receiveData(int byteCount){

while(Wire.available()) {
    number = Wire.read();
    //for example for Arduino Uno number can be 0 - 6
    if (number <= (MAX_PIN - MIN_PIN )){
      light = analogRead(number + MIN_PIN);
      //for debugging
      //Serial.println(light);
    }
  }
}
// callback for sending data
void sendData(){
    //split value to two bytes, maximal value is 1023 - 7 bit
    int first_byte = light >> 7;
    int second_byte = light - (first_byte * 128);
    Wire.write(first_byte);
    Wire.write(second_byte);
}
