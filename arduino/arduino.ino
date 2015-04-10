#include <SPI.h>
#include "Adafruit_BLE_UART.h"
#include <Servo.h>

#define ZERO 93
#define SPEED 80

#define ADAFRUITBLE_REQ 10
#define ADAFRUITBLE_RDY 2   // This should be an interrupt pin, on Uno thats #2 or #3
#define ADAFRUITBLE_RST 9
 
Adafruit_BLE_UART BTLEserial = Adafruit_BLE_UART( ADAFRUITBLE_REQ, ADAFRUITBLE_RDY, ADAFRUITBLE_RST );

Servo sA;
Servo sB;
Servo sC;
Servo sD;

boolean closingA = true;
boolean closingB = true;
boolean closingC = true;
boolean closingD = true;

void setup()
{
  Serial.begin( 9600 );
 
  BTLEserial.begin();  
  
  pinMode( A0, INPUT_PULLUP );
  pinMode( A1, INPUT_PULLUP );
  pinMode( A2, INPUT_PULLUP );
  pinMode( A3, INPUT_PULLUP );
  pinMode( A4, INPUT_PULLUP );
  pinMode( A5, INPUT_PULLUP );
  pinMode(  7, INPUT_PULLUP );
  pinMode(  8, INPUT_PULLUP );
}

aci_evt_opcode_t laststatus = ACI_EVT_DISCONNECTED;

void loop()
{
  BTLEserial.pollACI();
  
  aci_evt_opcode_t status = BTLEserial.getState();
  
  if( status != laststatus )
  {
    if( status == ACI_EVT_DEVICE_STARTED )
    {
        Serial.println( F( "* Started" ) );
    }
    
    if( status == ACI_EVT_CONNECTED)
    {
        Serial.println( F( "* Connected!" ) );
    }
    
    if( status == ACI_EVT_DISCONNECTED )
    {
        Serial.println( F( "* Disconnected or timed out" ) );
    }
    
    laststatus = status;
  }
  
  if( analogRead( A1 ) < 200 )
  {
    closingA = true;
    sA.detach();
  }
  
  if( analogRead( A0 ) < 200 )
  {
    closingA = false;
    sA.detach();
  }

  if( analogRead( A3 ) < 200 )
  {
    closingB = true;
    sB.detach();
  }
  
  if( analogRead( A2 ) < 200 )
  {
    closingB = false;
    sB.detach();
  }
  
  if ( analogRead( A5 ) < 200)
  {
    closingC = true;
    sC.detach();
  }
  
  if( analogRead( A4 ) < 200 )
  {
    closingC = false;
    sC.detach();
  }
  
  if( digitalRead( 8 ) == LOW )
  {
    closingD = true;
    sD.detach();
  }
  
  if( digitalRead( 7 ) == LOW )
  {
    closingD = false;
    sD.detach();
  }
  
  if( status == ACI_EVT_CONNECTED )
  {
    while( BTLEserial.available() )
    {
      char c = BTLEserial.read();
      Serial.println( c );
      
      if( c == '4' ) // green
      {
        sD.attach( 6 );
        if( closingD ) sD.write( ZERO - SPEED );
        else sD.write( ZERO + SPEED );
      }
      
      if( c == '2' ) // red
      {
        sC.attach( 5 );
        if( closingC ) sC.write( ZERO - SPEED );
        else sC.write( ZERO + SPEED );
      }
      
      if( c == '3' ) // teal
      {
        sB.attach( 4 );
        if( closingB ) sB.write( ZERO - SPEED );
        else sB.write( ZERO + SPEED );
      }
      
      if( c == '1' )
      {
        sA.attach( 3 );
        if( closingA ) sA.write( ZERO - SPEED );
        else sA.write( ZERO + SPEED );
      }
      
      delay( 40 );
      
      sA.detach();
      sB.detach();
      sC.detach();
      sD.detach();
    }
  }
}
