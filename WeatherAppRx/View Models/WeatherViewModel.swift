//
//  WeatherViewModel.swift
//  WeatherAppRx
//
//  Created by Magfurul Abeer on 10/14/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol WeatherViewModelInputsType {
//    var selectedIndex: Observable<Int>! { get set }
//    var filterText: Observable<String?>! { get set }
}

protocol WeatherViewModelOutputsType {
//    var displayedUsers: Observable<[User]> { get }
}

protocol WeatherViewModelActionsType {
//    func didSelectModel(user: User)
}

protocol WeatherViewModelType {
    var inputs: WeatherViewModelInputsType { get }
    var outputs: WeatherViewModelOutputsType { get }
    var actions: WeatherViewModelActionsType { get }
}

class WeatherViewModel: WeatherViewModelType {
    var inputs: WeatherViewModelInputsType { return self }
    var outputs: WeatherViewModelOutputsType { return self }
    var actions: WeatherViewModelActionsType { return self }
    
    let provider = MoyaProvider<OpenWeatherAPI>()

    // MARK: Input
    var query = Variable<String?>(nil)
    
    // MARK: Output
    lazy var currentWeather: Observable<Weather?> = {
        return self.query.asObservable()
            .filter { $0 != nil && $0 != "" }
            .flatMap { self.provider.rx.request(OpenWeatherAPI.currentWeather($0!)) }
            .map { response in
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                    return try Weather(data: json)
                } catch let e {
                    // Not enough time to implement proper error handling
                    print("ERROR")
                }
                return nil
            }
    }()
    
    lazy var temperature: Observable<String> = {
        return self.currentWeather
            .map { weather in
                guard let weather = weather else {
                    return "😱"
                }
                return "\(weather.temperature)° K"
            }
    }()
    
    lazy var humidity: Observable<String> = {
        return self.currentWeather
            .map { weather in
                guard let weather = weather else {
                    return "n/a"
                }
                return "\(weather.humidity)%"
        }
    }()

    lazy var pressure: Observable<String> = {
        return self.currentWeather
            .map { weather in
                guard let weather = weather else {
                    return "n/a"
                }
                return "\(weather.pressure)in"
        }
    }()
    
    lazy var descriptionText: Observable<String> = {
        return self.currentWeather
            .map { weather in
                guard let weather = weather else {
                    return ""
                }
                return weather.description.capitalized
        }
    }()
    
    lazy var iconUrl: Observable<URL?> = {
        return self.currentWeather
            // I prefer to write this in shorthand as $0 != nil
            // Unfortunately it confuses the compiler and gives an
            // 'Ambiguous use of filter' error
            .filter({ (weather) -> Bool in
                if let weather = weather {
                    return true
                } else {
                    return false
                }
            })
            .map { $0!.icon }
            .map { icon -> URL? in
                var components = URLComponents()
                components.scheme = "https"
                components.host = "api.openweathermap.org"
                components.path = "/img/w/\(icon)"
                return components.url
            }
    }()
    
//    lazy var icon: Observable<String> = {
//        return self.currentWeather
//            .map { weather in
//                guard let weather = weather else {
//                    return ""
//                }
//                return weather.description.capitalized
//        }
//    }()
}



extension WeatherViewModel: WeatherViewModelInputsType, WeatherViewModelOutputsType, WeatherViewModelActionsType { }

