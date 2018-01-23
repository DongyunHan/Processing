import java.text.SimpleDateFormat;

Date returnLocalTime(Location loc){
  JSONObject json;
  
 // try{
    //Hawaii make the error
    json = loadJSONObject("https://maps.googleapis.com/maps/api/timezone/json?"
          +"location="+loc.getLat() +","+ loc.getLon() +"&timestamp=" + timeStamp +"&key="+GOOGLE_TIMEZONE_API_KEY);
  //}catch(NullPointerException e){
  //  return new Date();
  //}
  
  return new Date((long)(json.getFloat("rawOffset") + json.getFloat("dstOffset") + timeStamp)*1000);
}

public class CurrentInfo{
  String country;
  String city;
  float pm10;
  float pm25;
  Location loc;
  float lat;
  float lon;
  Date dateTime;
  
  public CurrentInfo(){}
  
  public CurrentInfo(String country, String city, float pm10, float pm25, float lat, float lon, Date dateTime){
    this.country = country;
    this.city = city;
    this.pm10 = pm10;
    this.pm25 =pm25;
    
    this.lat =lat;
    this.lon = lon;
    this.loc = new Location(lat, lon);
    
    this.dateTime = new Date();
    this.dateTime = dateTime; 
  }
  
  public CurrentInfo(String country, String city, float pm10, float pm25, Location loc, Date dateTime){
    this.country = country;
    this.city = city;
    this.pm10 = pm10;
    this.pm25 =pm25;
    
    this.lat = loc.getLat();
    this.lon = loc.getLon();
    this.loc = new Location(loc);
    
    this.dateTime = new Date();
    this.dateTime = dateTime; 
  }
  
  public String getCountry(){
     return this.country; 
  }
 
  public void setCountry(String country){
     this.country = country; 
  }
  
  public String getCity(){
     return this.city; 
  }
  
  public void setCity(String city){
     this.city = city; 
  }
  
  public float getPM10(){
      return this.pm10; 
  }
  
  public void setPM10(float pm10){
      this.pm10 = pm10; 
  }
  
  public float getPM25(){
      return this.pm25; 
  }
  
  public void setPM25(float pm25){
      this.pm25 = pm25; 
  }
  
  public Location getLoc(){
     return this.loc; 
  }
  
  public void setLoc(Location loc){   
     this.loc =loc;
     
     this.lat = loc.getLat();
     this.lon = loc.getLon();
  }
  
  public Date getTime(){
     return this.dateTime;
  }
  
  public void setTime(Date time){
     this.dateTime = time;
  }
  
  /*
  public Date ticktock(){
      //make dateTime update
  }
  */
 
   
  /*
  void draw(float sensorX, float sensorY) {
    loc_x -= sensorX;
    loc_y -= sensorY;
    
    blurred_circle(loc_x, loc_y, depth*radius, abs(depth-FOCAL_LENGTH), shaded_color, MIN_BLUR_LEVELS + (depth * BLUR_LEVEL_COUNT));
    dust_line(loc_y, loc_x, radius, abs(depth-FOCAL_LENGTH), shaded_color_dust, MIN_BLUR_LEVELS + (depth*BLUR_LEVEL_COUNT), angle);     
   
  }
  */
}