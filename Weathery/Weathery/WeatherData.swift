//
//  WeatherData.swift
//  Weathery
//
//  Created by Cong Le on 3/11/22.
//
import Foundation

struct WeatherData: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct Main: Decodable {
    let temp: Double
}
