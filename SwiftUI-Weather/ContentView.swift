//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Gangadhar C on 9/26/23.
//

import SwiftUI
import Foundation

func WeatherIcon(icon:String,dayTime:Int)->String{
    
    let iconDayType: [String:String] = ["Thunderstorm":"cloud.bolt.rain.fill",
                                        "Rain": "cloud.sun.rain.fill",
                                        "Drizzle":"cloud.drizzle.fill",
                                        "Snow":"snowflake",
                                        "Mist":"cloud.fog.fill",
                                        "Smoke":"cloud.fog.fill",
                                        "Haze":"cloud.fog.fill",
                                        "Dust":"cloud.fog.fill",
                                        "Fog":"cloud.fog.fill",
                                        "Sand":"cloud.fog.fill",
                                        "Ash":"cloud.fog.fill",
                                        "Squall":"cloud.fog.fill",
                                        "Tornado":"cloud.fog.fill",
                                        "Clear":"sun.max.fill",
                                        "Clouds":"cloud.sun.fill"
                                        ]
    let iconNightType: [String:String] = ["Thunderstorm":"cloud.bolt.rain.fill",
                                          "Rain": "cloud.moon.rain.fill",
                                          "Drizzle":"cloud.drizzle.fill",
                                          "Snow":"snowflake",
                                          "Mist":"cloud.fog.fill",
                                          "Smoke":"cloud.fog.fill",
                                          "Haze":"cloud.fog.fill",
                                          "Dust":"cloud.fog.fill",
                                          "Fog":"cloud.fog.fill",
                                          "Sand":"cloud.fog.fill",
                                          "Ash":"cloud.fog.fill",
                                          "Squall":"cloud.fog.fill",
                                          "Tornado":"cloud.fog.fill",
                                          "Clear":"moon.fill",
                                          "Clouds":"cloud.moon.fill"
                                            ]
    if(dayTime<18 && dayTime>=6){
        if let item = iconDayType["Rain"]
        {
            return item
        }
        else{
            return "sun.max.trianglebadge.exclamationmark.fill"
        }
    }
    else
    {
        if let item = iconNightType["Rain"]
        {
            return item
        }
        else{
            return "sun.max.trianglebadge.exclamationmark.fill"
        }

    }
    
}
func SmallView(weekday:String,temperature:Double,imagename:String) -> some View {
    VStack(spacing: 15){
        if let item = Int(weekday, radix: 10)! >= 12 ?" pm": " am"{
            Text(String(Int(weekday, radix: 10)!%12 == 0 ? 12 : Int(weekday, radix: 10)!%12 ) + item  ).font(.system(size: 25, weight: .medium, design: .default)).foregroundColor(.white)
        }
       
        Image(systemName: imagename)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60,height: 60)
        Text(String(Int(temperature))+"°").font(.system(size: 32,weight: .medium, design: .default)).foregroundColor(.white)
        Spacer()
    }
}
struct City:Codable{
    let name:String
    let lat:Double
    let lon:Double
}

struct WeatherResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherData]
    let city: CityData
}

struct WeatherData: Codable {
    let dt: TimeInterval
    let main: MainData
    let weather: [WeatherInfo]
    let clouds: CloudData
    let wind: WindData
    let visibility: Int
    let sys: SysData
    let dt_txt: String
}

struct MainData: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let sea_level: Int
    let grnd_level: Int
    let humidity: Int
    let temp_kf: Double
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct CloudData: Codable {
    let all: Int
}

struct WindData: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct SysData: Codable {
    let pod: String
}

struct CityData: Codable {
    let id: Int
    let name: String
    let coord: CoordData
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct CoordData: Codable {
    let lat: Double
    let lon: Double
}

func getWeatherDetails(cityname:String) async throws -> WeatherResponse? {
    let url = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(cityname)&limit=1&appid=2af789c41b934be69f4777295e83362d")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let wrapper = try JSONDecoder().decode([City].self, from: data)
    var _wrapper=wrapper.isEmpty ? City(name: "empty", lat: 0.0, lon: 0.0) : wrapper[0]
    let _url = URL(string:
                    "https://api.openweathermap.org/data/2.5/forecast?lat=\(_wrapper.lat)&lon=\(_wrapper.lon)&units=metric&appid=2af789c41b934be69f4777295e83362d")!
    let (_data, _) = try await URLSession.shared.data(from: _url)
    let result = try JSONDecoder().decode(WeatherResponse.self, from: _data)
    return result
}
func stringToDate(dateString: String) -> Date? {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

  return dateFormatter.date(from: dateString)
}

struct ContentView: View {
    @State var Location:String
    @State var city:City? = nil
    @State var cityweather:WeatherResponse? = nil
    @State var emptyDictionary = [String: Int]()
    @State var showSearchView=true
    
    var body: some View {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color("CustomBlue"),Color("CustomBlue"),Color("CustomGray")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                VStack(){
                    VStack(spacing: 5){
                        if let cityweather{
                            
                            Text(cityweather.city.name)
                                .font(.system(size: 32, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding()
                            
                            Image(systemName: WeatherIcon(icon:cityweather.list[0].weather[0].main, dayTime: Int(String(cityweather.list[0].dt_txt.split(separator: " ")[1]).split(separator: ":")[0])!))
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180,height:180)
                            Text(String(cityweather.list[0].main.temp)+"°C")
                                .font(.system(size: 70,weight: .medium))
                                .foregroundColor(.white)
                            Spacer(minLength: 70)
                        }
                        else{
                            Spacer()
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).controlSize(.large)
                            
                        }
                        
                    }
                    HStack(spacing: 20){
                        
                        ForEach(0..<4,id:\.self){num in
                            let _d=cityweather?.list[num]
                            if let _d{
                                SmallView(weekday:String(String(_d.dt_txt.split(separator: " ")[1]).split(separator: ":")[0]),temperature:_d.main.temp, imagename: WeatherIcon(icon: _d.weather[0].main, dayTime: Int(String(_d.dt_txt.split(separator: " ")[1]).split(separator: ":")[0])!))
                                
                            }
                        }
                        
                    }
                    VStack{
                        Spacer()
                        Button("Change Location", systemImage:"location.fill" , action:{showSearchView.toggle()}).font(.system(size: 20,weight: .medium)).frame(width: 300)
                            .padding().background( RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        Spacer()
                    }.sheet(isPresented: $showSearchView,onDismiss: {
                        Task{
                            do{
                                    cityweather=try await getWeatherDetails(cityname: Location)
                            }catch{
                                cityweather=nil
                            }
                        }
                    }, content: {
                        LocationSearchView(Location:$Location)
                    })
                    .task(priority:.high){
                        do{
                                cityweather=try await getWeatherDetails(cityname: Location)
                        }catch{
                            cityweather=nil
                        }
                    }
                }
            }
        }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(Location:"anantapur")
            
            ContentView(Location: "anantapur")
                .environment(\.colorScheme, .dark)
        }
    }
}
