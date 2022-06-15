//
//  DetailViewController.swift
//  OpenWeatherByWOOJIN
//
//  Created by 효우 on 2022/06/15.
//

import UIKit


class DetailViewController: UIViewController {
    
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var baseVIew: UIView!
    
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var feelLikeTemp: UILabel!
    @IBOutlet weak var tempDesc: UILabel!
    @IBOutlet weak var weatherMain: UILabel!
    @IBOutlet weak var humi: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var atmospheric: UILabel!
    @IBOutlet weak var sunRise: UILabel!
    @IBOutlet weak var sunSet: UILabel!
    @IBOutlet weak var visibility: UILabel!
    
    var cityText: String = ""
    var curruntTempText: String = ""
    var maxTempText: String = ""
    var minTempText: String = ""
    var feelLikeTempText: String = ""
    var tempDescText: String = ""
    var weatherMainText: String = ""
    var humiText: String = ""
    var windText: String = ""
    var atmosphericText: String = ""
    var visibilityText: String = ""
    var sunsetInt: Date = Date()
    var sunRiseInt: Date = Date()
    var timeZoneInt: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headView.layer.cornerRadius = 15
        bottomView.layer.cornerRadius = 10
        baseVIew.layer.cornerRadius = 10
        
        name.text = cityText
        currentTemp.text = "\(curruntTempText)°"
        maxTemp.text = "최고:\(maxTempText)°"
        minTemp.text = "최저:\(minTempText)°"
        feelLikeTemp.text = "체감기온:\(feelLikeTempText)°"
        weatherMain.text = "\(weatherMainText) 𝄅 "
        tempDesc.text = tempDescText
        humi.text = "\(humiText)%"
        wind.text = "\(windText)m/s"
        atmospheric.text = "\(atmosphericText)㍱"
        visibility.text = "\(visibilityText)㎞"
        
        sunSet.text = getHourForDate(sunsetInt)
        sunRise.text = getHourForDate(sunRiseInt)
        
    }
    
    func getHourForDate(_ date: Date?)-> String{
        guard let date = date else {return "error"}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
    
    
}
