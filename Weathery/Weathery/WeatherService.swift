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
    
    func fetchWeather(cityName: String) {
        let weatherModel  = WeatherModel(conditionId: 700, cityName: cityName, temperature: -10)
        delegate?.didFetchWeather(self, weatherModel)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let weatherModel = WeatherModel(conditionId: 800, cityName: "Paris", temperature: 25)
        delegate?.didFetchWeather(self, weatherModel)
    }
}

/*
The advantages or protocol-delegate are:
 - its precision
 - its ability to interface with any entity
 - its clarity - you can see what exactly is going on
 
Its disadvantages
 - it can seems foreign - not a common pattern used in other languages
 - easy to forget to set yourself up as the delegate - common mistake
 
 UIKit heavily use protocol-delegate pattern
 */
