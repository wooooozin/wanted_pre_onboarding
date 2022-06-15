//
//  WeatherResponse.swift
//  OpenWeatherByWOOJIN
//
//  Created by 효우 on 2022/06/13.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let sys: Sys
    let name: String? // 도시이름
    let cod: Int?
    let timezone: Date?
    let visibility: Int?
}

struct Weather: Codable {
    let id: Int?
    let main: String? // 현재날씨
    let description: String? // 날씨설명
    let icon: String? // 날씨 아이콘
}

struct Main: Codable {
    let temp: Double? // 현재기온
    let feels_like: Double? // 체감기온
    let temp_min: Double? //최저기온
    let temp_max: Double? // 최고기온
    let pressure: Int? // 기압
    let humidity: Int?// 습도
}

struct Wind: Codable {
    let speed: Double? // 풍속
    let deg: Int?
}

struct Sys: Codable {
    let sunrise: Date?
    let sunset: Date?
}
