//
//  WeatherService.swift
//  Weathery
//
//  Created by Cong Le on 3/11/22.
//

import Foundation
import CoreLocation

enum ServiceError: Error {
    case network(statusCode: Int)
    case parsing
    case general(reason: String)
}

protocol WeatherServiceDelegate: AnyObject {
    func didFetchWeather(_ weatherService: WeatherService, _  weather: WeatherModel)
    func didFailWithError(_ weatherService :WeatherService, _ error: ServiceError)
}

struct WeatherService {
    weak var delegate: WeatherServiceDelegate?
    
    let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=aa738fd3d8027f7059994e8bdca7ef3c&units=metric")!
    
    func fetchWeather(cityName: String) {
        guard let urlEncodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            assertionFailure("Could not encode city named: \(cityName)") // Debug only
            return
        }
        let urlString = "\(String(describing: weatherURL))&q=\(urlEncodedCityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let urlString = "\(String(describing: weatherURL))&lat=\(latitude)&lon=\(longtitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                let generalError = ServiceError.general(reason: "Check network availability.")
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(self, generalError)
                }
                return
            }
            
            guard let safeData = data,
                  let httpResponse = response as? HTTPURLResponse
            else { return }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print(httpResponse.statusCode)
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(self, ServiceError.network(statusCode: httpResponse.statusCode))
                }
                return
            }
            
            guard let weather = self.parseJSON(safeData) else { return }
            
            DispatchQueue.main.async {
                self.delegate?.didFetchWeather(self, weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        guard let decodedData = try? JSONDecoder().decode(WeatherData.self, from: weatherData) else {
            DispatchQueue.main.async {
                self.delegate?.didFailWithError(self, ServiceError.parsing)
            }
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
