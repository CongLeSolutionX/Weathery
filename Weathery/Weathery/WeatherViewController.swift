//
//  WeatherViewController.swift
//  Weathery
//
//  Created by Cong Le on 3/9/22.
//

import UIKit

class WeatherViewController: UIViewController {
    let rootStackView = UIStackView()
    
    // search
    let searchStackView = UIStackView()
    let locationButton = UIButton()
    let searchTextField = UITextField()
    let searchButton = UIButton()
    
    // weather
    let conditionImageView = UIImageView()
    let temperatureLabel = UILabel()
    let cityLabel = UILabel()
    
    let backgroundView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup() // Step 2. Register observers
        style()
        layout()
    }
}
// MARK: -
extension WeatherViewController {
    func setup() {
        // Register for a notification
        /// When register a notification, we need to specify:
        /// - `observer` who is observing this notification. In this case it is us so we can just pass in `self`
        /// - `selector` the function that is going to execute when this notification is received.
        /// - `name` the name of this event. This is of type `NSNotification.Name?`
        /// - `object` the object that sends the notification to us. We don’t really care who sends us the notification. So we can just put `nil` here.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveWeather),
            name: .didReceiveWeather,
            object: nil
        )
    }
    
    func style() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        rootStackView.alignment = .trailing
        rootStackView.spacing = 10
        
        // search
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.spacing = 10
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.tintColor = .label
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title1)
        searchTextField.placeholder = "Search"
        searchTextField.textAlignment = .right
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .systemFill
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchPressed(_:)), for: .primaryActionTriggered)
        searchButton.tintColor = .label
        
        // weather
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.image = UIImage(systemName: "sun.max")
        conditionImageView.tintColor = .label
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 80)
        temperatureLabel.attributedText = makeTemperatureText(with: "22")
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        cityLabel.text = "Cupertino"
        
        // background
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named: "day-background")
        backgroundView.contentMode = .scaleAspectFill
    }
    
    func layout(){
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        rootStackView.addArrangedSubview(searchStackView)
        rootStackView.addArrangedSubview(conditionImageView)
        rootStackView.addArrangedSubview(temperatureLabel)
        rootStackView.addArrangedSubview(cityLabel)
        
        view.addSubview(backgroundView)
        view.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1),
            searchStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            
            locationButton.widthAnchor.constraint(equalToConstant: 44),
            locationButton.heightAnchor.constraint(equalToConstant: 44),
            
            searchButton.widthAnchor.constraint(equalToConstant: 44),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
            conditionImageView.widthAnchor.constraint(equalToConstant: 120),
            
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
   
    private func makeTemperatureText(with temperature: String) -> NSAttributedString {
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.boldSystemFont(ofSize: 100)

        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.systemFont(ofSize: 80)

        let text = NSMutableAttributedString(string: temperature, attributes: boldTextAttributes)
        text.append(NSAttributedString(string: "°C", attributes: plainTextAttributes))

        return text
    }
}
// MARK: - Helper Methods
extension WeatherViewController {
    @objc
    func searchPressed(_ sender: UIButton) {
        let service = WeatherNotificationService()
        service.fetchWeather(cityName: "New York")
    }
    // Step 4: Get notified
    // Execute this function when we receive the event
    @objc func receiveWeather(_ notification: Notification) {
        guard let data = notification.userInfo as? [String: WeatherModel] else { return }
        guard let weatherModel = data["currentWeather"] else { return }
        
        temperatureLabel.attributedText = makeTemperatureText(with: weatherModel.temperatureString)
        conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        cityLabel.text = weatherModel.cityName
    }
}
