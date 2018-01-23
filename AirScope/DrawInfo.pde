boolean isPressed = false;

int dustIndex = 0;
CurrentInfo curInfo;

String date2String(Date d){
  return new SimpleDateFormat("yyyy / MM / dd").format(d) + "\n" +new SimpleDateFormat("HH : mm : ss").format(d);
}

void drawInfo(){
      if(screen_x_pos < 350){
        String lines = "";
        
        textFont(font);
        //textFont(helveFont);
        fill(0,0,0,150);
        textAlign(CENTER,CENTER);
        textSize(25);
        textLeading(25);  // Set leading to 20
        
        lines = curInfo.getCity();
        text(lines,100, height/2);
        
        textSize(15);
        lines = "\n" + curInfo.getCountry() + "\n";
          
        if(dustIndex == 0){         
          if(curInfo.getPM10() != 0){
            lines =lines + "PM10 : " + curInfo.getPM10() +"\n";
          }else{
            mouseCLICK_LEFT();      
            //lines =lines + "PM10 : " + null +"\n";
          }
        }else if(dustIndex == 1){
          if(curInfo.getPM25()!= 0){
              lines =lines + "PM25 : " + curInfo.getPM25() +"\n";
          }else{          
            mouseCLICK_LEFT();
            //lines =lines + "PM25 : " + null +"\n";
         }
        }
              
          text(lines, 100, height/2 + 30);
          
          textSize(13);   
          lines = date2String(curInfo.getTime());
          //text(lines, width - 100, height/2);
          text(lines, 100, height/2+ 200);
    }
}


void loadData(String name1, String name2, float pm10_value, float pm25_value, float lat_value, float lon_value, Date time){
  curInfo.setCountry(name1);
  curInfo.setCity(name2);
  curInfo.setPM10(pm10_value);
  curInfo.setPM25(pm25_value);
  curInfo.setLoc(new Location(lat_value,lon_value));
  curInfo.setTime(time);
   
  N = getDustValue();
  updateBubbles();
}

void selectDust(){
  N = getDustValue();
}

float getDustValue(){
  switch (dustIndex){
    case 0:
      if(curInfo.getPM10() != 0)
        return curInfo.getPM10();
      else
        return curInfo.getPM25();
    case 1:
      if(curInfo.getPM25() != 0)
        return curInfo.getPM25();
      else
        return curInfo.getPM10();
    default:
      return 99;
  }
}