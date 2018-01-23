

//Draw blue range circle  
final int ZOOM_3_RANGE = 15;
final int ZOOM_4_RANGE = 14;
final int ZOOM_5_RANGE = 10;

final int PINPOINT_RANGE = 2;

boolean buttonPressed = false;

void buttonClick(int pin){
  GPIO.noInterrupts();
  
  if(GPIO.digitalRead(pin) == GPIO.LOW){
     buttonPressed = true;
     
     stopWatch.start();
  }
  
  GPIO.interrupts();
}

void buttonRelease(int pin){
  GPIO.noInterrupts();
  
  if(GPIO.digitalRead(pin) == GPIO.HIGH){
    stopWatch.reset();
    
    if(!isPressed){     
        mouseCLICK_LEFT();
    }else{
        stopWatch.reset();
        updateBubbles();
        
        //After finish the map mode reset the starting point
        map.panTo(curInfo.getLoc()); 
      }
      
    buttonPressed = false;
    isPressed = false;    
  }
  
  GPIO.interrupts();
}

int rotateLevel = 0;
final int ROTATESTEP = 4;

void zoomEvent(int pin){
  GPIO.noInterrupts();
  
  if(buttonPressed){
    if(GPIO.digitalRead(17) == GPIO.HIGH && GPIO.digitalRead(18) == GPIO.HIGH)
    {
      rotateLevel--; 
      
      if(rotateLevel == -ROTATESTEP){        
        map.mapDisplay.setProvider(provider1);
        
        zoomLevel = ZOOM_IN;
        map.zoomAndPanTo(current,zoomLevel);
      }else if(rotateLevel == 0){
        
        map.mapDisplay.setProvider(provider2);
        
        zoomLevel = ZOOM_INIT;
        map.zoomAndPanTo(current,zoomLevel);
      }else if(rotateLevel == ROTATESTEP){
          
        map.mapDisplay.setProvider(provider3);
        
        zoomLevel = ZOOM_OUT;
        map.zoomAndPanTo(current,zoomLevel);
      }else if(rotateLevel < -ROTATESTEP){
         rotateLevel++; 
      }
        
          
      println("counter clockwise");
      println(rotateLevel);    
    }else if(GPIO.digitalRead(17) == GPIO.LOW && GPIO.digitalRead(18) == GPIO.HIGH){
       
      rotateLevel++;
      
      if(rotateLevel == -ROTATESTEP){        
        map.mapDisplay.setProvider(provider1);
        
        zoomLevel = ZOOM_IN;
        map.zoomAndPanTo(current,zoomLevel);
      }else if(rotateLevel == 0){
        
        map.mapDisplay.setProvider(provider2);
        
        zoomLevel = ZOOM_INIT;
        map.zoomAndPanTo(current,zoomLevel);
      }else if(rotateLevel == ROTATESTEP){
          
        map.mapDisplay.setProvider(provider3);
        
        zoomLevel = ZOOM_OUT;
        map.zoomAndPanTo(current,zoomLevel);
      }else if(rotateLevel > ROTATESTEP){
         rotateLevel--; 
      }
      
      println("clockwise");
      
      println(rotateLevel);
      
    }
  }
  
  GPIO.interrupts();
}


void mouseClicked() {
    stopWatch.start();
}

void mouseCLICK_LEFT(){         
        dustIndex = (dustIndex+1) % 2;
        N = getDustValue();
        updateBubbles(); 
}

void mouseReleased(){
  if(!isPressed){
      if (mouseButton == LEFT) {
        mouseCLICK_LEFT();
      } 
  }else{
    
    stopWatch.reset();
    updateBubbles();
    
    //After finish the map mode reset the starting point
    map.panTo(curInfo.getLoc()); 
  }
  
 stopWatch.reset();
 isPressed = false; 
}


//Map zoomin and zoomout 
//Under zoomlevel is set to 3 for zoomOUT 
//                      and 4 for zoomIN
void zoomKeyPressed(){
   if(key == 'q'){    
      zoomLevel = 4;
      map.zoomAndPanTo(current,zoomLevel);
   }else if(key == 'w'){
      zoomLevel = 3;
      map.zoomAndPanTo(current,zoomLevel);
   }
}


void drawNearMarkers() {
  float curLat = current.getLat();
  float curLon = current.getLon();
  float markerLat;
  float markerLon;
  
  // Deselect all marker
  multiMarker_major.setHidden(true);   
  multiMarker_major.setSelected(false);

  if(zoomLevel == 3){
      //draw the range.
      noStroke();
      fill(67,211,227,10);
      ellipse(z_pos, x_pos, 240, 240); 
    
      for (Marker marker : multiMarker_major.getMarkers()) {
        markerLat = marker.getLocation().getLat();
        markerLon = marker.getLocation().getLon();
        
        if(markerLat > curLat - ZOOM_3_RANGE
                && markerLat < curLat + ZOOM_3_RANGE
                  && markerLon > curLon - ZOOM_3_RANGE
                    && markerLon < curLon +ZOOM_3_RANGE){
             
            marker.setHidden(false);  
            
            if(markerLat > curLat - PINPOINT_RANGE
                && markerLat < curLat + PINPOINT_RANGE
                  && markerLon > curLon - PINPOINT_RANGE
                    && markerLon < curLon + PINPOINT_RANGE){
               marker.setSelected(true);  
             }  
            
         }      
      }
  }else if(zoomLevel == 4){
      //draw the range.
      noStroke();
      fill(67,211,227,10);
      //ellipse(z_pos, x_pos, 400, 400); 
      ellipse(y_pos, x_pos, 400, 400);
      
      for (Marker marker : multiMarker_major.getMarkers()) {
        markerLat = marker.getLocation().getLat();
        markerLon = marker.getLocation().getLon();
        
        if(markerLat > curLat - ZOOM_4_RANGE
                && markerLat < curLat + ZOOM_4_RANGE
                  && markerLon > curLon - ZOOM_4_RANGE
                    && markerLon < curLon + ZOOM_4_RANGE){
             
            marker.setHidden(false);  
            
            if(markerLat > curLat - PINPOINT_RANGE
                && markerLat < curLat + PINPOINT_RANGE
                  && markerLon > curLon - PINPOINT_RANGE
                    && markerLon < curLon + PINPOINT_RANGE){
               marker.setSelected(true);  
             }
         }      
      }
  } else if(zoomLevel == 5){
      //draw the range.
      noStroke();
      fill(67,211,227,10);
      ellipse(z_pos, x_pos, 400, 400); 
      
      for (Marker marker : multiMarker_major.getMarkers()) {
        markerLat = marker.getLocation().getLat();
        markerLon = marker.getLocation().getLon();
        
        if(markerLat > curLat - ZOOM_5_RANGE
                && markerLat < curLat + ZOOM_5_RANGE
                  && markerLon > curLon - ZOOM_5_RANGE
                    && markerLon < curLon + ZOOM_5_RANGE){
             
            marker.setHidden(false);  
            
            if(markerLat > curLat - PINPOINT_RANGE
                && markerLat < curLat + PINPOINT_RANGE
                  && markerLon > curLon - PINPOINT_RANGE
                    && markerLon < curLon + PINPOINT_RANGE){
               marker.setSelected(true);  
             }
         }      
      }
  } 
}