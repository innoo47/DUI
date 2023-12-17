
import UIKit

class Define: Any {
    
    // Google Map API KEY
    static let GOOGLE_API_KEY   = "AIzaSyCcqx_Pf6dnf7hLZmGyIeI4gKoo2zawWX8"
    static let MAP_ID           = "aa679bd95b287b42"
    
    // OpenWeatherMap API 엔드포인트 및 API 키
    static let apiKey = "f4d187ee1fb7182adbf58d4c089491a4"
    static let endpoint = "https://api.openweathermap.org/data/2.5/weather"
    static let city = "Daejeon, KR" // 날씨 정보를 얻고자 하는 도시
    
    // 구글지도 좌표계 -> WGS 84 (교내 편의시설 기본 좌표)
    static let LAT_001          = 36.336059
    static let LONG_001         = 127.459963
    
    // 구글지도 좌표계 -> WGS 84 (주변 음식점 기본 좌표)
    static let LAT_002          = 36.335088
    static let LONG_002         = 127.457517
    
    static let BOARD_REG_DATE_TYPE  = "yyyyMMddHHmmss"
    
}
