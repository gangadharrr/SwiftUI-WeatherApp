//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Gangadhar C on 9/26/23.
//

import SwiftUI
import Foundation
func SmallView(weekday:String,temperature:Double,imagename:String) -> some View {
    VStack(spacing: 15){
        if let item = Int(weekday, radix: 10)! >= 12 ? " am": " pm"{
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



func getCityDetails(cityname:String) async throws -> City? {
    
    let url = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(cityname)&limit=1&appid=2af789c41b934be69f4777295e83362d")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let wrapper = try JSONDecoder().decode([City].self, from: data)
    return wrapper[0]
    
}
func getWeatherDetails(lat:Double,lon:Double) async throws -> WeatherResponse? {
 
    let url = URL(string:
                    "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=2af789c41b934be69f4777295e83362d")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let wrapper = try JSONDecoder().decode(WeatherResponse.self, from: data)
    return wrapper
}
func stringToDate(dateString: String) -> Date? {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

  return dateFormatter.date(from: dateString)
}

struct ContentView: View {
    @State var city:City?
    @State var cityweather:WeatherResponse?
    @State var emptyDictionary = [String: Int]()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue,Color("LightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            VStack(){
                if let city{
                    Text(city.name)
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .padding()
                }
                else{
                   ProgressView()
                }
                
                VStack(spacing: 5){
                    Image(systemName: "cloud.sun.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180,height:180)
                    if let cityweather{
                        Text(String(cityweather.list[0].main.temp)+"°C")
                            .font(.system(size: 70,weight: .medium))
                            .foregroundColor(.white)
                        Spacer(minLength: 70)
                    }
                    else{
                        ProgressView().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
                    }
                   
                }
        
                HStack(spacing: 20){
                    
                    ForEach(0..<4,id:\.self){num in
                            let _d=cityweather?.list[num]
                            if let _d{
                                SmallView(weekday:String(String(_d.dt_txt.split(separator: " ")[1]).split(separator: ":")[0]),temperature:_d.main.temp, imagename:"cloud.sun.fill")
                            
                        }
                    }
                    
                }
                VStack{
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Change Location").font(.system(size: 20,weight: .medium)).frame(width: 300)
                    }).padding().background( RoundedRectangle(cornerRadius: 8).fill(Color.white)
                        .stroke(Color.white, lineWidth: 2))
                   Spacer()
                }.task(priority:.high){
                    do{
                        city = try await getCityDetails(cityname: "anantapur")
                        if let city{
                            cityweather=try await getWeatherDetails(lat:city.lat,lon:city.lon)
                        }
                        
                    }catch{
                        cityweather=nil
                        city=nil
                    }
                }
            }
            
           }
        }
        
}



#Preview {
    ContentView()
}

