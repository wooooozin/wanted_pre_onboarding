//
//  WeatherDataManager.swift
//  OpenWeatherByWOOJIN
//
//  Created by 효우 on 2022/06/13.
//

import Foundation
import UIKit
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherDataManager {
    
    func getWeather(cityName: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=47228ae38ba58f5d99a291937c257ebd&q=\(cityName)")
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            
            if let weatherResponse = weatherResponse {
                completion(.success(weatherResponse))
            } else {
                completion(.failure(.decodingError))
            }
        }
        .resume()
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        if let hasURL = URL(string: urlString) {
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            
            session.dataTask(with: request) { data, response, error in
//                print((response as! HTTPURLResponse).statusCode)

                if let hasData = data {
                  completion(UIImage(data: hasData))
                    return
                }
            }
            .resume()
            session.finishTasksAndInvalidate()
        }
        completion(nil)
    }

}
