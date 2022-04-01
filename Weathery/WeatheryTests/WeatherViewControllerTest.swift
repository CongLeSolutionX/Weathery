//
//  WeatherViewControllerTest.swift
//  WeatherViewControllerTest
//
//  Created by Cong Le on 3/31/22.
//

import XCTest
import CoreLocation
@testable import Weathery /// give access  to all the classes in our main project target Weathery

class WeatherViewControllerTest: XCTestCase {
    // Set up the view controller
    var viewController: WeatherViewController!
    
    override func setUp() {
        viewController = WeatherViewController()
        viewController.loadViewIfNeeded()
    }
    
    func testCanGetWeatherAndPopulateView() {
        // Given
        let weatherModel = WeatherModel(conditionId: 1, cityName: "Tokyo", temperature: 20)
        let mockWeatherService = WeatherServiceMock(delegate: viewController, weatherModel: weatherModel, error: nil)
        
        viewController.weatherService = mockWeatherService /// inject mock service into viewController (the object under test)
        
        // When
        mockWeatherService.fetchWeather(cityName: "Tokyo")
        
        // Then
        XCTAssertEqual("Tokyo", viewController.cityLabel.text)
        XCTAssertEqual("20°C", viewController.temperatureLabel.attributedText?.string)
    }
    
    func testCanHandleGeneralErrors() {
        // Given
        let error = ServiceError.general(reason: "Internet down")
        let mockWeatherService = WeatherServiceMock(delegate: viewController, weatherModel: nil, error: error)
        
        viewController.weatherService = mockWeatherService /// inject mock service into viewController (the object under test)
        
        // When
        mockWeatherService.fetchWeather(cityName: "Tokyo")
        
        // Then
        XCTAssertEqual("Internet down", viewController.errorMessage!)
        
    }
    
    func testNetworkErrors() {
        // Given
        let error = ServiceError.network(statusCode: 404)
        let mockWeatherService = WeatherServiceMock(delegate: viewController, weatherModel: nil, error: error)
        
        // When
        mockWeatherService.fetchWeather(cityName: "Tokyo")
        
        // Then
        XCTAssertEqual("Network error with status code: 404", viewController.errorMessage!)
    }
    
    func testParsingErrors() {
        // Given
        let error = ServiceError.parsing
        let mockWeatherService = WeatherServiceMock(delegate: viewController, weatherModel: nil, error: error)
        
        mockWeatherService.fetchWeather(cityName: "Tokyo")
        
        XCTAssertEqual("JSON weather data could not be parsed.", viewController.errorMessage!)
        
    }
}

// MARK: - WeatherServiceMock
struct WeatherServiceMock: WeatherServiceProtocol {
    weak var delegate: WeatherServiceDelegate?
    
    var weatherModel: WeatherModel?
    var error: ServiceError?
    
    func fetchWeather(cityName: String) {
        fetch()
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        fetch()
    }
    
    func fetch() {
        if let error = error {
            delegate?.didFailWithError(self, error)
            return
        }
        
        guard let weatherModel = weatherModel else { return }
        delegate?.didFetchWeather(self, weatherModel)

    }
}
