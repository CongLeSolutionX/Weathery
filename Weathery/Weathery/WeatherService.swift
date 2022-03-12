//
//  WeatherService.swift
//  Weathery
//
//  Created by Cong Le on 3/11/22.
//

import Foundation
import CoreLocation

protocol WeatherServiceDelegate: AnyObject {
    func didFetchWeather(_ weatherService: WeatherService, _  weather: WeatherModel)
}

struct WeatherService {
    weak var delegate: WeatherServiceDelegate?
    
    let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=aa738fd3d8027f7059994e8bdca7ef3c&units=metric")!
    
    func fetchWeather(cityName: String) {
        let urlString = "\(String(describing: weatherURL))&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let urlString = "\(String(describing: weatherURL))&lat=\(latitude)&lon=\(longtitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    DispatchQueue.main.async {
                        self.delegate?.didFetchWeather(self, weather)
                    }
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        guard let decodedData = try? JSONDecoder().decode(WeatherData.self, from: weatherData) else {
            return nil
        }
        
        let id = decodedData.weather[0].id
        let temp = decodedData.main.temp
        let name = decodedData.name
        
        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        return weather
    }
}
// MARK: -
// unwrap url string via using fallable initializer
//extension URL {
//    init?(_ string: StaticString) {
//        self.init(string: "\(string)")
//    }
//}
