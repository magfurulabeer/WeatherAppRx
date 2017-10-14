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
    var query: Variable<String?> { get set }
}

protocol WeatherViewModelOutputsType {
    var currentWeather: Observable<Weather?> { get }
    var temperature: Observable<String> { get }
    var humidity: Observable<String> { get }
    var pressure: Observable<String> { get }
    var descriptionText: Observable<String> { get }
    var iconUrl: Observable<URL?> { get }
}

// In most cases I try to avoid adding code I won't be using since YAGNI
// but I generally try to follow this convention when working with RxSwift View Models
// since I usually end up adding Actions eventually
protocol WeatherViewModelActionsType {
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
    var didPressDone = Variable<()>()
    
    // MARK: Output
    lazy var currentWeather: Observable<Weather?> = {
        return
            self.didPressDone.asObservable()
            .withLatestFrom(self.query.asObservable())
            .filter { $0 != nil && $0 != "" }
            .do(onNext: { query in
                UserDefaults.standard.set(query!, forKey: Constants.lastSearchedKey)
            })
            .flatMap { self.provider.rx.request(OpenWeatherAPI.currentWeather($0!)) }
            .map { response in
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
    
    lazy var name: Observable<String?> = {
        Observable.combineLatest(self.query.asObservable(), self.currentWeather)
        { (queryString: $0, weather: $1) }
            .map { queryString, weather in
                guard let weather = weather else {
                    return queryString
                }
                return weather.name
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
}

extension WeatherViewModel: WeatherViewModelInputsType, WeatherViewModelOutputsType, WeatherViewModelActionsType { }

