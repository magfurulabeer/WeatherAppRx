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
        case .currentWeatherCoordinates:
            return "/data/2.5/weather"
        case .icon(let name):
            return "/img/w/\(name)"
        }
    }
    
    public var method: Moya.Method {
        return Moya.Method.get
    }

}

//public func url(route: MoyaTarget) -> String {
//    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString!
//}

//class OpenWeatherService {
//    func currentWeather(city: String) -> Observable<Weather> {
//        return buildRequest(pathComponent: "weather", params: [("q", city)])
//            .map { json in
//                return Weather(
//                    cityName: json["name"].string ?? "Unknown",
//                    temperature: json["main"]["temp"].int ?? -1000,
//                    humidity: json["main"]["humidity"].int  ?? 0,
//                    icon: iconNameToChar(icon: json["weather"][0]["icon"].string ?? "e")
//                )
//        }
//    }
//
//    //MARK: - Private Methods
//
//    /**
//     * Private method to build a request with RxCocoa
//     */
//    private func buildRequest(method: String = "GET", pathComponent: String, params: [(String, String)]) -> Observable<JSON> {
//
//        let url = baseURL.appendingPathComponent(pathComponent)
//        var request = URLRequest(url: url)
//        let keyQueryItem = URLQueryItem(name: "appid", value: apiKey)
//        let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
//        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
//
//        if method == "GET" {
//            var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
//            queryItems.append(keyQueryItem)
//            queryItems.append(unitsQueryItem)
//            urlComponents.queryItems = queryItems
//        } else {
//            urlComponents.queryItems = [keyQueryItem, unitsQueryItem]
//
//            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//            request.httpBody = jsonData
//        }
//
//        request.url = urlComponents.url!
//        request.httpMethod = method
//
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let session = URLSession.shared
//
//        return session.rx.data(request: request).map { JSON(data: $0) }
//    }
//}

