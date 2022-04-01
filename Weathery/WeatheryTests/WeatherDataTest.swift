//
//  WeatherDataTest.swift
//  WeatheryTests
//
//  Created by Cong Le on 3/31/22.
//

import XCTest
@testable import Weathery /// give access  to all the classes in our main project target Weathery

class WeatherDataTest: XCTestCase {
    
    func testCanParseWeather() throws {
        let json = """
        {
            "weather": [
                {
                    "id": 804,
                    "description": "overcast clouds",
                }
            ],
            "main": {
                "temp": 10.58,
            },
            "name": "Calgary"
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)
        
        XCTAssertEqual(10.58, weatherData.main.temp)
        XCTAssertEqual("Calgary", weatherData.name)
        XCTAssertEqual(804, weatherData.weather[0].id)
        XCTAssertEqual("overcast clouds", weatherData.weather[0].description)
    }
    func testCanParseWeatherWithEmptyCityName() throws {
        let json = """
        {
            "weather": [
                {
                    "id": 804,
                    "description": "overcast clouds",
                }
            ],
            "main": {
                "temp": 10.58,
            },
            "name": ""
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let weatherData = try! JSONDecoder().decode(WeatherData.self, from: jsonData)
     
        XCTAssertEqual("", weatherData.name)
    }
}
