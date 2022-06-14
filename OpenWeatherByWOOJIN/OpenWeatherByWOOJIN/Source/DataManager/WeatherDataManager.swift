//
//  WeatherDataManager.swift
//  OpenWeatherByWOOJIN
//
//  Created by 효우 on 2022/06/13.
//

import Foundation
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
                print(weatherResponse)
                completion(.success(weatherResponse))
            } else {
                completion(.failure(.decodingError))
            }
        }
        .resume()
    }
}
