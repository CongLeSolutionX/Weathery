//
//  WeatherNotificiationService.swift
//  Weathery
//
//  Created by Cong Le on 3/10/22.
//

import Foundation
// Step 1: Define the event type `didReceiveWeather`
extension Notification.Name {
    static let didReceiveWeather = Notification.Name("didReceiveWeather")
}

struct WeatherNotificationService {
    
    func fetchWeather(cityName: String) {
        // Creating a hardcoded WeatherModel and data
        let weatherModel = WeatherModel(conditionId: 200, cityName: cityName, temperature: 22)
        let data = ["currentWeather": weatherModel]
        //Step 3. Fire the event when the event occurs
        NotificationCenter.default.post(name: .didReceiveWeather, object: nil, userInfo: data)
    }
}
/*
Notification Center is a great pattern to use if:
 - you have multiple parties you need to update, or
 - the entity you want to update if far away from where the event occurs
 
It’s strengths are:
 - Ease of use.
 - Ability to send messages to far off places.
 - Multiple parties can receive the same event.

while it’s downsides are:
 - It can make the code difficult to follow.
 - You need to be more careful when making changes.
 - It can be overused and makes apps difficult to maintain.
 
For these reasons we tend to use Notification Center more sparingly, and save it for those instances where:
 - parties we want to notify live in hard to reach places in the app, and
 - multiple parties really need to be updated when a certain events occurs
 
 */
