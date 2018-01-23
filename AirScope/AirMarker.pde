import de.fhpotsdam.unfolding.geo.Location;
import de.fhpotsdam.unfolding.marker.SimplePointMarker;
import java.util.Date;
import java.sql.Timestamp;

MultiMarker multiMarker_major;

void addAirMarkers(){
   multiMarker_major = new MultiMarker();
  
   JSONArray json = loadJSONArray("AirScope_DATA.json");
   JSONObject data, loc, pollution;
   String country_val, city_val;
   
   float pm10_val, pm25_val; 
   float local_lon_val, local_lat_val;
   
   for(int i=0; i<json.size(); i++){
       data = json.getJSONObject(i);
             
       pollution = data.getJSONObject("pollution");
       
       country_val = data.getString("country").replace("%20", " ");
       city_val = data.getString("city").replace("%20", " ");
           
       loc = data.getJSONObject("loc");
       local_lon_val = loc.getFloat("lon");
       local_lat_val = loc.getFloat("lat");
       
       Location loc_country = new Location(local_lat_val, local_lon_val);
       
       pm10_val = pollution.getFloat("pm10");
       pm25_val = pollution.getFloat("pm25");
                     
                                      
       //this is necessary to initialize screen
       if(country_val.equals("South Korea")){   
          curInfo = new CurrentInfo();
          loadData(country_val, city_val, pm10_val, pm25_val, STARTING_POINT.getLat(),STARTING_POINT.getLon() , returnLocalTime(STARTING_POINT));
       }
                          
       AirMarker newMarker = new AirMarker(loc_country, country_val, city_val, pm10_val, pm25_val, local_lon_val, local_lat_val);
          
       multiMarker_major.addMarkers(newMarker);
   }
  multiMarker_major.setHidden(true);
  map.addMarkers(multiMarker_major);
}


public class AirMarker extends SimplePointMarker {
  float o3;
  float pm10;
  float pm25;
  float local_lon;
  float local_lat;
  Location local_loc;
  String name;
  String name2;
   
 
  public AirMarker(Location location, String name, String name2, float pm10, float pm25, float local_lon, float local_lat) {
    super(location);
    this.name =name;
    this.name2 = name2;
    this.pm10 = pm10;
    this.pm25 = pm25;
    
    this.local_lon = local_lon;
    this.local_lat = local_lat;
    this.local_loc = new Location(this.local_lat,this.local_lon);
  }
  
  public void draw(PGraphics pg, float x, float y) {
    float loc_x = x;
    float loc_y = y;
    
    pg.pushStyle();
    if(!hidden){
      pg.noFill();
      //Draw circle #1
      pg.stroke(67,211,227,255);
      pg.strokeWeight(4);
      pg.ellipse(x, y, 26, 26);
      //Draw circle #2
      pg.stroke(67,211,227,50);
      pg.strokeWeight(5);
      pg.ellipse(x, y, 30, 30);
      
      loc_x +=17;
      loc_y -=15;
      //Draw info
      pg.fill(0,0,0);
      pg.textFont(helveFont);
      pg.text(name, loc_x, loc_y);
      
      if(name2!=null){
         loc_y +=12;
         pg.text(": "+ name2, loc_x, loc_y);
      }
      
      if(pm10!= 0){
        loc_y+=12;
        pg.text("PM10 : " + pm10, loc_x, loc_y);
      }
      
      if(pm25!= 0){
        loc_y+=12;
        pg.text("PM2.5 : " + pm25, loc_x, loc_y);
      }
      pg.popStyle();
      
      if(selected){
          pg.noFill();
          pg.stroke(255,0,0,150);
          pg.strokeWeight(5);
          pg.ellipse(x, y, 30, 30);         
                
          loadData(this.name, this.name2, this.pm10, this.pm25, this.local_lat, this.local_lon,  returnLocalTime(local_loc));
      }
    }
  }
}