import UIKit
import FirebaseDatabase
import GoogleMaps
import GooglePlaces
import Firebase
import CoreLocation

class ResMapController: UIViewController, GMSMapViewDelegate {
    
    
    var mapView: GMSMapView!
    var markers: [Int: [GMSMarker]] = [:] // 버튼의 tag를 키로 사용, 각 버튼에 대한 마커 배열
    var markerStates: [Int: Bool] = [:]
    var selectedButton: UIButton?
    var ref: DatabaseReference!
    
    var content: String = ""
    var categoryTitle: String = ""
    
    let locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Database Reference 가져오기
        ref = Database.database().reference()

        // Google 지도 초기화
        let camera = GMSCameraPosition.camera(withLatitude: Define.LAT_002, longitude: Define.LONG_002, zoom: 17.77)
        let mapID = GMSMapID(identifier: Define.MAP_ID) // mapID로 지도의 스타일 변경
        mapView = GMSMapView(frame: .zero, mapID: mapID, camera: camera)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false

        if let mapView = mapView {
            view.addSubview(mapView)

            NSLayoutConstraint.activate([
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        // 접근성
        mapView.accessibilityElementsHidden = true
        
        // 내 위치 활성화 여부
        mapView.isMyLocationEnabled = true
        
        // 내 위치 이동 버튼 생성
        mapView.settings.myLocationButton = true
        
        // 나침반 생성
        mapView.settings.compassButton = true
        
        // 최대 줌 설정
        mapView.setMinZoom(16, maxZoom: 19)

        // 경계 설정
        let vancouver = CLLocationCoordinate2D(latitude: 36.342359, longitude: 127.451776)
        let calgary = CLLocationCoordinate2D(latitude: 36.322751,longitude: 127.466634)
        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)

        // 화면 이동을 특정 영역으로 제한
        mapView.cameraTargetBounds = bounds
        
        
        // UIScrollView 생성
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.isScrollEnabled = true // 스크롤 가능 여부

        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            scrollView.heightAnchor.constraint(equalToConstant: 50)
        ])

        let button1 = createButton(title: "   카페   ", tag: 1)
        let button2 = createButton(title: "   편의점   ", tag: 2)
        let button3 = createButton(title: "   한식   ", tag: 3)
        let button4 = createButton(title: "   일식   ", tag: 4)
        let button5 = createButton(title: "   중식   ", tag: 5)
        let button6 = createButton(title: "   패스트푸드   ", tag: 6)
        let button7 = createButton(title: "   치킨   ", tag: 7)
        let button8 = createButton(title: "   피자   ", tag: 8)
        let button9 = createButton(title: "   족발   ", tag: 9)
        let button10 = createButton(title: "   기타   ", tag: 10)

        
        // 카테고리 버튼을 담을 수평 스택뷰 생성
        let categoryStackView = UIStackView()
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 10 // 버튼 간의 간격 설정
        
        // 카테고리 스택에 버튼 추가
        button1.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button4.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button5.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button6.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button7.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button8.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button9.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button10.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        categoryStackView.addArrangedSubview(button1)
        categoryStackView.addArrangedSubview(button2)
        categoryStackView.addArrangedSubview(button3)
        categoryStackView.addArrangedSubview(button4)
        categoryStackView.addArrangedSubview(button5)
        categoryStackView.addArrangedSubview(button6)
        categoryStackView.addArrangedSubview(button7)
        categoryStackView.addArrangedSubview(button8)
        categoryStackView.addArrangedSubview(button9)
        categoryStackView.addArrangedSubview(button10)
        
        // 카테고리 스택뷰를 스크롤뷰에 추가
        scrollView.addSubview(categoryStackView)
        
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            categoryStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            categoryStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        

        self.directionTest()
        
        // 날씨 정보 뷰 생성
        // 뷰 생성 및 화면에 추가
        let vWeatherInfoView = WeatherInfoView()
        vWeatherInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vWeatherInfoView)

        // 화면에 추가된 customView에 대한 제약 조건
        NSLayoutConstraint.activate([
            vWeatherInfoView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 3),
            vWeatherInfoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 3),
            vWeatherInfoView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 106),
            vWeatherInfoView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        
    }
    
    
    // 경로
    func directionTest() {
        
        // 일본
        let originLatitude = 34.03887901056528 // 시작 위도
        let originLongitude = 131.8512689120819 // 시작 경도
        let destinationLatitude = 43.1368075169225 // 도착 위도
        let destinationLongitude = 141.42493501345194 // 도착 경도
        
        let origin = "\(originLatitude),\(originLongitude)"
        let destination = "\(destinationLatitude),\(destinationLongitude)"

        
        // Call the Google Directions API to get route information
        let directionsURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(Define.GOOGLE_API_KEY)"

        
        print("DirectionsURL : \(directionsURL)")
        if let url = URL(string: directionsURL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let routes = json["routes"] as? [[String: Any]] {
                                if let route = routes.first,
                                   let overviewPolyline = route["overview_polyline"] as? [String: String],
                                   let points = overviewPolyline["points"] {
                                    // Decode the polyline points and create a GMSPolyline
                                    if let path = GMSPath(fromEncodedPath: points) {
                                        let polyline = GMSPolyline(path: path)
                                        polyline.strokeWidth = 3.0
                                        polyline.map = self.mapView
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    
    // 마커를 선택할 때 호출됨
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) {
        print("마커를 선택했습니다. 제목: \(marker.title ?? "")")
    }
    
    // 탭한 곳의 위도와 경도를 나타낼 수 있는 메소드
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("didTapAt \(coordinate.latitude), \(coordinate.longitude)")
 
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        print("didLongPressAt \(coordinate.latitude), \(coordinate.longitude)")
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print("didTapInfoWindowOf \(marker.title)")
    }
    
    
    // 미커핀의 제목을 길게 탭했을 시 (세부정보 표시)
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf \(String(describing: marker.title))")
        
        if let location_title = marker.title{
                    if let resMapDetailVC = storyboard?.instantiateViewController(withIdentifier: "ResMapdetailViewController") as? ResMapdetailViewController {

                        resMapDetailVC.categoryName = categoryTitle
                        resMapDetailVC.Atitle = location_title
                        resMapDetailVC.cam = "주변 음식점"

                        //모달 표시
                        present(resMapDetailVC, animated: true, completion: nil)
                    }
                }
    }
    
    
    // 장소 위치 정보
    func placeInfoLocation(_ inputText:String){
        
        // Google Places API Key
        let apiKey = Define.GOOGLE_API_KEY

        // 사용자가 입력한 주소 또는 장소 이름
        let inputText = inputText // 예: "서울시청" (검색할 주소 또는 장소 이름)

        // Google Places API의 요청 URL
        let baseURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?"

        guard let encodedStr = inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let input = encodedStr
        let fields = "formatted_address,name,geometry"
        let requestURL = "\(baseURL)input=\(input)&inputtype=textquery&fields=\(fields)&key=\(apiKey)"
        print("placeInfoLocation \(requestURL)")
        if let url = URL(string: requestURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("에러 발생: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                            let candidates = json["candidates"] as? [[String: Any]],
                            let candidate = candidates.first,
                            let geometry = candidate["geometry"] as? [String: Any],
                           let location = geometry["location"] as? [String: Double],
                               let lat = location["lat"],
                               let lng = location["lng"] {
                               print("좌표: \(lat), \(lng)")
                           }
                    } catch {
                        print("JSON 파싱 오류: \(error)")
                    }
                }
            }
            task.resume()
        }

        
    }
    
    // 장소 운영시간 및 정보 가져오기
    func placeInfoSearch(_ inputPlaceID: String, viewController: ResMapController) {
        // Google Places API Key
        let apiKey = Define.GOOGLE_API_KEY

        // 장소의 Place ID (Google Places API에서 검색한 결과의 place_id)
        let placeID = inputPlaceID

        // Google Places API의 요청 URL
        let baseURL = "https://maps.googleapis.com/maps/api/place/details/json?"
        let requestURL = "\(baseURL)placeid=\(placeID)&fields=name,opening_hours&key=\(apiKey)"
        print("placeInfoSearch \(requestURL)")
        if let url = URL(string: requestURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("에러 발생: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                            let result = json["result"] as? [String: Any],
                            let openingHours = result["opening_hours"] as? [String: Any],
                            let weekdayText = openingHours["weekday_text"] as? [String] {
                            var hoursText = ""
                            for hours in weekdayText {
                                hoursText += hours + "\n"
                            }
                            
                            // 영업 시간 정보를 메인 스레드에서 UITextView에 설정
                            DispatchQueue.main.async {
                              
                            }
                        }
                    } catch {
                        print("JSON 파싱 오류: \(error)")
                    }
                }
            }
            task.resume()
        }
    }

    
    // 버튼 생성
    func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
        
        //button.setImage(UIImage(named: "img.jpg")! as UIImage, for: .normal) // 이미지 설정
        button.backgroundColor = UIColor.systemBackground // 버튼 배경색 설정
        button.layer.cornerRadius = 11 // 모서리 둥글게 설정
        
        // 그림자 설정
        button.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor // 그림자 색상 설정
        button.layer.shadowOpacity = 0.3 // 그림자 투명도 설정
        button.layer.shadowOffset = CGSize(width: 1, height: 1) // 그림자 오프셋 설정
        
        // 테두리 설정
        button.layer.borderWidth = 1 // 테두리 두께 설정
        button.layer.borderColor = UIColor.systemBackground.cgColor // 테두리 색상 설정
        
        button.tag = tag // 버튼의 tag 속성을 설정
        return button
    }
    
    // 버튼 클릭 시
    @objc func buttonTapped(sender: UIButton) {
        if let prevButton = selectedButton, prevButton != sender {
            let prevButtonTag = prevButton.tag
            deleteMarkers(tag: prevButtonTag) // 이전 버튼에 대한 모든 마커 삭제
            markerStates[prevButtonTag] = false
        }

        let buttonTag = sender.tag

        if let isMarkerShown = markerStates[buttonTag] {
            if isMarkerShown {
                deleteMarkers(tag: buttonTag) // 현재 버튼에 대한 모든 마커 삭제
                markerStates[buttonTag] = false
                selectedButton = nil
            } else {
                addMarkersForButton(tag: buttonTag) // 현재 버튼에 대한 모든 마커 추가
                markerStates[buttonTag] = true
                selectedButton = sender
            }
        } else {
            addMarkersForButton(tag: buttonTag) // 현재 버튼에 대한 모든 마커 추가
            markerStates[buttonTag] = true
            selectedButton = sender
        }
    }
    
    // 버튼 별 마커추가 // 추후에 DB에서 데이터를 가져올 예정
    func addMarkersForButton(tag: Int) {
        switch tag {
        case 1: // 카페
            addFirebasePins(categoryName: "카페")
            categoryTitle="카페"
        case 2: // 편의점
            addFirebasePins(categoryName: "편의점")
            categoryTitle="편의점"
        case 3: // 한식
            addFirebasePins(categoryName: "한식")
            categoryTitle="한식"
        case 4: // 일식
            addFirebasePins(categoryName: "일식")
            categoryTitle="일식"
        case 5: // 중식
            addFirebasePins(categoryName: "중식")
            categoryTitle="중식"
        case 6: // 패스트푸드
            addFirebasePins(categoryName: "패스트푸드")
            categoryTitle="패스트푸드"
        case 7: // 치킨
            addFirebasePins(categoryName: "치킨")
            categoryTitle="치킨"
        case 8: // 피자
            addFirebasePins(categoryName: "피자")
            categoryTitle="피자"
        case 9: // 족발
            addFirebasePins(categoryName: "족발")
            categoryTitle="족발"
        case 10: // 기타
            addFirebasePins(categoryName: "기타")
            categoryTitle="기타"
        default:
            break
        }
    }
    
    
    
    
    // 마커 추가
    func addMarker(latitude: Double, longitude: Double, title: String, placeID: String, content: String, buttonTag: Int) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = title
        marker.map = mapView
        if markers[buttonTag] == nil {
            markers[buttonTag] = [marker]
        } else {
            markers[buttonTag]?.append(marker)
        }
        
        
    }
    
    // Firebase 데이터를 가져와 핀을 추가하는 메소드
      func addFirebasePins(categoryName: String) {
          // Firebase 데이터베이스에서 "주변 음식점" 위치의 데이터를 가져옵니다.
          ref.child("주변 음식점").child(categoryName).observe(.value) { (snapshot) in
              for child in snapshot.children {
                  if let pinSnapshot = child as? DataSnapshot,
                     let pinData = pinSnapshot.value as? [String: Any],
                     let latitude = pinData["latitude"] as? Double,
                     let longitude = pinData["longitude"] as? Double,
                     let title = pinData["title"] as? String,
                     let placeID = pinData["placeID"] as? String,
                     let tag = pinData["tag"] as? Int,
                     let content = pinData["content"] as? String {
                      
                      // content가 비어 있어도 마커 추가
                      self.addMarker(latitude: latitude, longitude: longitude, title: title, placeID: placeID, content: content, buttonTag: tag)
                      
                      // placeID가 비어있지 않으면 상세 정보를 가져옴
                      if !placeID.isEmpty {
                          self.fetchPlaceDetails(placeID: placeID, buttonTag: tag)
                      }
                  }
              }
          }
      }

    
    // Google Places API를 사용하여 장소 정보 가져오고 표시
    func fetchPlaceDetails(placeID: String, buttonTag: Int) {
        let placesClient = GMSPlacesClient.shared()

        // Place ID를 사용하여 장소 정보 가져오기
        placesClient.lookUpPlaceID(placeID) { (place, error) in
            if let error = error {
                print("장소 상세 정보 오류: \(error.localizedDescription)")
                return
            }

            if let place = place {
                let marker = GMSMarker()
                marker.position = place.coordinate
                marker.title = place.name
                marker.snippet = place.formattedAddress
                marker.map = self.mapView

                if self.markers[buttonTag] == nil {
                    self.markers[buttonTag] = [marker]
                } else {
                    self.markers[buttonTag]?.append(marker)
                }

                // 뷰 컨트롤러를 매개변수로 placeInfoSearch 함수를 호출
                self.placeInfoSearch(placeID, viewController: self)
            }
        }
    }

    // 마커 삭제
    func deleteMarkers(tag: Int) {
        if let markersForButton = markers[tag] {
            for marker in markersForButton {
                marker.map = nil
            }
            markers[tag] = nil
        }
    }
    
    
}
