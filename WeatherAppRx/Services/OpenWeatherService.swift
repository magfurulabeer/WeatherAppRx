//
//  OpenWeatherService.swift
//  WeatherAppRx
//
//  Created by Magfurul Abeer on 10/14/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Moya

// MARK: - Provider support

public enum OpenWeatherAPI {
    case currentWeather(String)
    case currentWeatherCoordinates(CGFloat, CGFloat)
    case icon(String)
}

extension OpenWeatherAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    // Not using this for this challenge
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .currentWeather(let query):
            return Task.requestParameters(parameters: ["q": query as NSString, "APPID": Constants.openWeatherAppId as NSString],
                                          encoding: URLEncoding.default)
        case .currentWeatherCoordinates(let lat, let lon):
            return Task.requestParameters(parameters: ["lat": lat as NSNumber, "lon": lon as NSNumber, "APPID": Constants.openWeatherAppId as NSString],
                                          encoding: URLEncoding.default)
        default:
            return Task.requestPlain
        }
    }
    
    public var parameters: [String: AnyObject] {
        switch self {
        case .currentWeather(let query):
            return ["q": query as NSString]
        case .currentWeatherCoordinates(let lat, let lon):
            return ["lat": lat as NSNumber, "lon": lon as NSNumber]
        default:
            return [:]
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
    public var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .currentWeatherCoordinates: // This was put in place if I ever get the chance to use location in this one
            return "/data/2.5/weather"
        case .icon(let name):
            return "/img/w/\(name)"
        }
    }
    
    public var method: Moya.Method {
        return Moya.Method.get
    }

}

