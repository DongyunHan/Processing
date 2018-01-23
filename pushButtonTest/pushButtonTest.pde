import processing.io.*;

void setup(){
  //When the Button is connected with Gpio pin#23 
  GPIO.pinMode(23, GPIO.INPUT);
  
  //GPIO.attachInterrupt(22, this, "pinEvent", GPIO.RISING); 
  //frameRate(0.5);
}

/*
void pinEvent(int pin) {
 fill(0); 
}
*/

void draw(){
  if(GPIO.digitalRead(23) == GPIO.HIGH){
     fill(0);       
  }else{
     fill(255);
  }
  
  stroke(255);
  ellipse(width/2, height/2, width*0.75, height*0.75);
}