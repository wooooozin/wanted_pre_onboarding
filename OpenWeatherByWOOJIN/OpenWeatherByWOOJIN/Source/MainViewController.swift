//
//  MainViewController.swift
//  OpenWeatherByWOOJIN
//
//  Created by 효우 on 2022/06/12.
//

import UIKit

var name: [String] = []
var weatherDesc: [String] = []
var icon: [String] = []
var temperature: [String] = []
var feelTemp: [String] = []
var minTemp: [String] = []
var maxTemp: [String] = []
var airPressure: [String] = []
var humi: [String] = []
var windSpeed: [String] = []

let celsiusUnit = UnitTemperature.celsius
let cityList = ["Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"]

class MainViewController: UIViewController{
    
    @IBOutlet weak var weatherTableView: UITableView!
    let celsiusUnit = UnitTemperature.celsius
    var arrCityList = cityList.sorted()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        
        setData()
        
    }
    
    func setData() {
        for index in 0..<arrCityList.count {
            WeatherDataManager().getWeather(cityName: arrCityList[index]) { result in
                switch result {
                case .success(let weatherResponse):
                    // 도시 이름
                    name.append(weatherResponse.name ?? "")
                    // 날씨 설명
                    weatherDesc.append(weatherResponse.weather[0].description ?? "")
                    // 날씨 아이콘
                    icon.append(weatherResponse.weather[0].icon ?? "")
                    // 현재 온도
                    temperature.append(String(format: "%0.f", self.celsiusUnit.converter.value(fromBaseUnitValue: weatherResponse.main.temp ?? 0)))
                    // 체감 온도
                    feelTemp.append(String(format: "%0.f", self.celsiusUnit.converter.value(fromBaseUnitValue: weatherResponse.main.feels_like ?? 0)))
                    // 최저 최고 기온
                    minTemp.append(String(format: "%0.f", self.celsiusUnit.converter.value(fromBaseUnitValue: weatherResponse.main.temp_min ?? 0)))
                    
                case .failure(_ ):
                    print("error")
                }
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                }
            }
        }
    }
   
}
    
    // MARK: - Extension
    extension MainViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return name.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let weatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
            
            weatherCell.cityLabel.text = name[indexPath.row]
            weatherCell.currentTempLabel.text = temperature[indexPath.row].description + "°"
            weatherCell.lowTempLabel.text = "최저:\(minTemp[indexPath.row])°"
            
            return weatherCell
        }
        
        private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                        
            tableView.deselectRow(at: indexPath, animated: true)
        
            
        }
        
        
    }
