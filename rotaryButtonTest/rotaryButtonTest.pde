import processing.io.*;

void pinEvent(int pin) {
  GPIO.noInterrupts();

  if(GPIO.digitalRead(17) == GPIO.HIGH && GPIO.digitalRead(18) == GPIO.HIGH)
  {
    println("counter clockwise");
    fill(255,0,0);
  }else if(GPIO.digitalRead(17) == GPIO.LOW && GPIO.digitalRead(18) == GPIO.HIGH){
    println("clockwise");
    fill(0,0,255); 
  }
  
  GPIO.interrupts();
}

void setup(){
   //I used the Rotary Button of
   //TSW A-3N-C LFS
   //And A-pin of Button is connected with GPIO #18
   //    B-pin of Button is connected with GPIO #17
   GPIO.pinMode(18, GPIO.INPUT);
   GPIO.pinMode(17, GPIO.INPUT);
   
   GPIO.attachInterrupt(18, this, "pinEvent", GPIO.RISING); 
}

void draw(){
  stroke(255);
  ellipse(width/2, height/2, width*0.75, height*0.75);
}