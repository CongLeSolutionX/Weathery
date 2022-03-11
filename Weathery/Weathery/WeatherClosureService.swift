//
//  WeatherClosureService.swift
//  Weathery
//
//  Created by Cong Le on 3/10/22.
//

import Foundation

struct WeatherClosureService {
    var receiveWeatherHandler: ((WeatherModel) -> Void)?
    func fetchWeather(cityName: String) {
        guard let receiveWeatherHandler = receiveWeatherHandler else { return }
        let weatherModel = WeatherModel(conditionId: 600, cityName: cityName, temperature: -10)
        receiveWeatherHandler(weatherModel)
    }
}

/*
The advantages of closures are:
 - they are first class citizens in Swift.
 - they enable us to write really expressive compact code
 - they can really simplify our programming models by enabling us to pass functions instead of objects.
 
The only downside to closures is the syntax.
 
The important takeaway here is to realize that:
 - functions have a type and can be passed and stored like any other variable
 - closures can be used as a way of communicating, and that
 - Swift is a functional language. Meaning you will be using closures/functions a lot when programming.

 */
