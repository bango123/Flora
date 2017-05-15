#include <Arduino.h>
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_UART.h"
#include <Adafruit_NeoPixel.h>

//SET Buffer for BLT and verbose_mode
#define BUFSIZE                        128   // Size of the read buffer for incoming data
#define VERBOSE_MODE                   true  // If set to 'true' enables debug output
char cmd[BUFSIZE+1];

//Pin definitions for BLT
#define BLUEFRUIT_HWSERIAL_NAME        Serial1
#define BLUEFRUIT_UART_MODE_PIN        -1    // Set to -1 if unused

//HW BLT object
Adafruit_BluefruitLE_UART ble(Serial1, BLUEFRUIT_UART_MODE_PIN); 

//Intializing the LED_Pixels
Adafruit_NeoPixel onBoard_Pix = Adafruit_NeoPixel(1, 8);
Adafruit_NeoPixel offBoard_Pixels = Adafruit_NeoPixel(20, 6);

//Error Helper
void error(const __FlashStringHelper*err) {
  Serial.println(err);
  while (1);
}

void setup() {
  //Initialize the NeoPixels :D :D
  onBoard_Pix.begin();
  onBoard_Pix.show();          // Initialize all pixels to 'off'
  offBoard_Pixels.begin();
  offBoard_Pixels.show();      // Initialize all pixels to 'off'

  
  Serial.begin(115200);
  
  Serial.print(F("Initialising the Bluefruit LE module: "));
  Serial.println(F("---------------------------------------"));

  if ( !ble.begin(VERBOSE_MODE) )
  {
    error(F("Couldn't find Bluefruit, make sure it's in CMD mode & check wiring?"));
  }
  Serial.println( F("Completed!") );

 /* Disable command echo from Bluefruit */
  ble.echo(false);

  Serial.println("Requesting Bluefruit info:");
  /* Print Bluefruit information */
  ble.info();

  Serial.println(F("Please use Adafruit Bluefruit LE app to connect in UART mode"));
  Serial.println(F("Then Enter characters to send to Bluefruit"));
  Serial.println();

  ble.verbose(false);  // debug info is a little annoying after this point!

  /* Wait for connection */
  while (! ble.isConnected()) {
      delay(500);
  }
  Serial.println(F("Connected"));
}

void loop(void)
{
  // Check for incoming characters from Bluefruit
  ble.println("AT+BLEUARTRX");
  ble.readline();
  if (strcmp(ble.buffer, "OK") == 0) {
    // no data
    return;
  }
  
  // Some data was found, its in the buffer
  strcpy(cmd, ble.buffer);
  Serial.print(F("[Recv] ")); Serial.println(cmd);
  ble.waitForOK();


  if(cmd[0]=='-'){
    //Encoding is as follows:
    //  -RRRRRRRR,GGGGGGGG,BBBBBBBB,LLLLL.
    //  Where each of the above is one bit
    //  So 5 bits for picking the LED (L) 0 = on board  1 to 20 is off board
    //  R is red pixel value (0 to 255)
    //  G is red pixel value (0 to 255)
    //  B is red pixel value (0 to 255)
    //  W is red pixel value (0 to 255)
  
    //Parse the input encoding:
    char *pch;
    pch = strtok(cmd, "-,.");
    int r = atoi(pch);
    Serial.print("R:"); Serial.println(r);
    
    pch = strtok(NULL, "-,.");
    int g = atoi(pch);
    Serial.print("G:"); Serial.println(g);
  
    pch = strtok(NULL, "-,.");
    int b = atoi(pch);
    Serial.print("B:"); Serial.println(b);
  
    pch = strtok(NULL, "-,.");
    int led = atoi(pch);
    Serial.print("L:"); Serial.println(led);

    //Send out the LED Command
    if(led == 0){
      onBoard_Pix.setPixelColor(led, r, g, b);
      onBoard_Pix.show();
    }
    else{
      led = led - 1;
      offBoard_Pixels.setPixelColor(led, r, g, b);
      offBoard_Pixels.show();
    }
  }
}
