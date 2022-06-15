//
//  MainViewController.swift
//  OpenWeatherByWOOJIN
//
//  Created by 효우 on 2022/06/12.
//

import UIKit

var weatherDataModel = WeatherDataModel()
let celsiusUnit = UnitTemperature.celsius
let cityList = ["Gongju", "Gwangju", "Gumi", "Gunsan", "Daegu", "Daejeon", "Mokpo", "Busan", "Seosan", "Seoul", "Sokcho", "Suwon", "Suncheon", "Ulsan", "Iksan", "Jeonju", "Jeju", "Cheonan", "Cheongju", "Chuncheon"]


class MainViewController: UIViewController{
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var weatherTableView: UITableView!
    
    let celsiusUnit = UnitTemperature.celsius
    var arrCityList = cityList.sorted()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        
        weatherTableView.estimatedRowHeight = 100
        weatherTableView.rowHeight = UITableView.automaticDimension
        
        indicatorView.startAnimating()
        setData()
        
    }
    // MARK: - Methods
    
    func setData() {
        for index in 0..<arrCityList.count {
            WeatherDataManager().getWeather(cityName: arrCityList[index]) { result in
                switch result {
                case .success(let weatherResponse):
                    // 도시 이름
                    weatherDataModel.name.append(weatherResponse.name ?? "")
                    // 날씨 설명
                    weatherDataModel.weatherDesc.append(weatherResponse.weather[0].description ?? "")
                    // 날씨 아이콘
                    weatherDataModel.icon.append(weatherResponse.weather[0].icon ?? "")
                    // 현재 온도
                    weatherDataModel.temperature.append(String(format: "%0.f", self.celsiusUnit.converter.value(fromBaseUnitValue: weatherResponse.main.temp ?? 0)))
                    // 체감 온도
                    weatherDataModel.feelTemp.append(String(format: "%0.f", self.celsiusUnit.converter.value(fromBaseUnitValue: weatherResponse.main.feels_like ?? 0)))
                    // 최저 최고 기온
                    weatherDataModel.minTemp.append(String(format: "%0.f", self.celsiusUnit.converter.value(fromBaseUnitValue: weatherResponse.main.temp_min ?? 0)))
                    
                    weatherDataModel.maxTemp.append(String(format: "%0.f", self.celsiusUnit.converter.value(fromBaseUnitValue: weatherResponse.main.temp_max ?? 0)))
                    
                    // 기압
                    weatherDataModel.atmosphericPressure.append(String(weatherResponse.main.pressure ?? 0))
                    
                    // 습도
                    weatherDataModel.humi.append(String(weatherResponse.main.humidity ?? 0))
                    // 풍속
                    weatherDataModel.windSpeed.append(String(format: "%0.f", weatherResponse.wind.speed ?? 0))
                    
                    // 현재 날씨
                    weatherDataModel.mainWeather.append(weatherResponse.weather[0].main ?? "")
                    
                    // 타임존
                    weatherDataModel.timeZone.append(weatherResponse.timezone ?? Date())
                    
                    // 일출, 일몰
                    weatherDataModel.sunset.append(weatherResponse.sys.sunset ?? Date())
                    weatherDataModel.sunrise.append(weatherResponse.sys.sunrise ?? Date())
                    
                    // 가시거리
                    weatherDataModel.visibility.append(String((weatherResponse.visibility ?? 0) / 1000))
                    
                case .failure(_ ):
                    print("error")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.weatherTableView.reloadData()
                    self.indicatorView.stopAnimating()
                    self.indicatorView.hidesWhenStopped = true
                }
            }
        }
    }
    
}

// MARK: - Extension
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataModel.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        
        weatherCell.cityLabel.text = weatherDataModel.name[indexPath.row]
        weatherCell.currentTempLabel.text = weatherDataModel.temperature[indexPath.row].description + "°"
        weatherCell.lowTempLabel.text = "최저:\(weatherDataModel.minTemp[indexPath.row])°"
        weatherCell.highTempLabel.text = "최고:\(weatherDataModel.maxTemp[indexPath.row])°"
        weatherCell.humidityLabel.text = "현재습도:\(weatherDataModel.humi[indexPath.row])%"
        
        // 날씨 아이콘
        let iconUrl =  "https://openweathermap.org/img/wn/\(weatherDataModel.icon[indexPath.row])@2x.png"
        WeatherDataManager().loadImage(urlString: iconUrl) { image in
            DispatchQueue.main.async {
                weatherCell.weatherIconImageView.image = image
            }
        }
        
        return weatherCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        let iconUrl =  "https://openweathermap.org/img/wn/\(weatherDataModel.icon[indexPath.row])@2x.png"
        WeatherDataManager().loadImage(urlString: iconUrl) { image in
            DispatchQueue.main.async {
                detailVC.iconImageView.image = image
            }
        }
        
        detailVC.cityText = weatherDataModel.name[indexPath.row]
        detailVC.curruntTempText = weatherDataModel.temperature[indexPath.row]
        detailVC.maxTempText = weatherDataModel.maxTemp[indexPath.row]
        detailVC.minTempText = weatherDataModel.minTemp[indexPath.row]
        detailVC.feelLikeTempText = weatherDataModel.feelTemp[indexPath.row]
        detailVC.tempDescText = weatherDataModel.weatherDesc[indexPath.row]
        detailVC.weatherMainText = weatherDataModel.mainWeather[indexPath.row]
        detailVC.humiText = weatherDataModel.humi[indexPath.row]
        detailVC.windText = weatherDataModel.windSpeed[indexPath.row]
        detailVC.atmosphericText = weatherDataModel.atmosphericPressure[indexPath.row]
        detailVC.visibilityText = weatherDataModel.visibility[indexPath.row]
        detailVC.sunsetInt = weatherDataModel.sunset[indexPath.row]
        detailVC.sunRiseInt = weatherDataModel.sunrise[indexPath.row]
        
        detailVC.modalPresentationStyle = .popover
        self.present(detailVC, animated: true)
        
    }

}


