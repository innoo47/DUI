//
//  WeatherInfoView.swift
//  Test
//
//  Created by 박인호 on 11/13/23.
//

import UIKit

class WeatherInfoView: UIView {
    
    let weatherIconImageView = UIImageView()    // 날씨 아이콘을 표시할 이미지 뷰
    let temperatureLabel = UILabel()            // 온도를 표시할 레이블

    
    // 사용자 정의 뷰 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 사용자 정의 뷰의 초기화 및 서브뷰 추가
        self.setupSubviews() // 서브뷰 추가 및 레이아웃 설정
        setupConstraints()
        self.weatherInfo() // 뷰가 초기화될 때 weatherInfo 메서드를 호출합니다.
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // 사용자 정의 뷰의 초기화 및 서브뷰 추가
        setupSubviews()
        setupConstraints()
        self.weatherInfo() // 뷰가 초기화될 때 weatherInfo 메서드를 호출합니다.
    }

    // 서브뷰 추가 및 레이아웃 설정
    private func setupSubviews() {
        
        // 배경 색 설정
        self.backgroundColor = UIColor.systemBackground
        
        // 테두리를 둥글게 설정
        layer.cornerRadius = 10
        layer.masksToBounds = false

        // 그림자 설정
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        weatherIconImageView.contentMode = .scaleAspectFit // 또는 .scaleAspectFill
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        temperatureLabel.textAlignment = .center
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 20)
        temperatureLabel.sizeToFit() // 동적으로 글자 크기 변경
        
        addSubview(weatherIconImageView)
        addSubview(temperatureLabel)
        
//        print("TEMP : \(temperatureLabel)")
        
        
    }
    
    private func setupConstraints() {
        // 왼쪽 weatherIconImageView의 제약 조건
        NSLayoutConstraint.activate([
            weatherIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            weatherIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 50),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 오른쪽 temperatureLabel의 레이블 제약 조건
        NSLayoutConstraint.activate([
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 50),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // 날씨 정보를 가져오는 메소드
    func weatherInfo() {
        
        if let url = URL(string: "\(Define.endpoint)?q=\(Define.city)&appid=\(Define.apiKey)&units=metric") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("날씨 정보를 가져오는 데 실패했습니다: \(error)")
                } else if let data = data {
                    // JSON 데이터 파싱 및 필요한 정보 추출
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let weatherData = json as? [String: Any],
                       let main = weatherData["main"] as? [String: Any],
                       let temperature = main["temp"] as? Double {
                        
                        // 날씨 상태 코드 가져오기
                        if let weather = weatherData["weather"] as? [[String: Any]], let weatherID = weather.first?["id"] as? Int {
                            // 날씨 상태 코드에 따라 아이콘 결정
                            var iconFileName = "default.png" // 기본 아이콘
                            switch weatherID {
                            case 800:
                                iconFileName = "clear.png" // 맑음
                            case 801:
                                iconFileName = "partly_cloudy.png" // 약간 흐림
                            case 802:
                                iconFileName = "clouds.png" // 구름 조금
                            default:
                                iconFileName = "default.png" // 기본 아이콘
                            }
                            
                            DispatchQueue.main.async {
                                if let iconImage = UIImage(named: iconFileName) {
                                    self.weatherIconImageView.image = iconImage
                                } else {
                                    print("아이콘 이미지를 찾을 수 없습니다.")
                                }
                            }

                        }
                        
                        // 온도 정보 업데이트
                        DispatchQueue.main.async {
                            let temperatureString = "\(Int(temperature))°C"
                            self.temperatureLabel.text = temperatureString
                            print("temp : \(temperatureString)")
                        }

                    }
                }
            }
            task.resume()
        } else {
            print("유효하지 않은 URL입니다.")
        }
        
    }

}


