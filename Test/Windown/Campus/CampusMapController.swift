import UIKit
import FirebaseDatabase
import GoogleMaps
import GooglePlaces
import Firebase
import CoreLocation

class CampusMapController: UIViewController, GMSMapViewDelegate{

    var mapView: GMSMapView!
    var markers: [Int: [GMSMarker]] = [:] // 버튼의 tag를 키로 사용, 각 버튼에 대한 마커 배열
    var markerStates: [Int: Bool] = [:]
    var selectedButton: UIButton?
    var ref: DatabaseReference!
    var content: String = ""
    var categoryTitle: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Database Reference 가져오기
        ref = Database.database().reference()

        // Google 지도 초기화
        let camera = GMSCameraPosition.camera(withLatitude: Define.LAT_001, longitude: Define.LONG_001, zoom: 17.77)
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
        mapView.setMinZoom(17.77, maxZoom: 19)
        
        // 경계 설정
        let vancouver = CLLocationCoordinate2D(latitude: 36.338861, longitude: 127.457018)
        let calgary = CLLocationCoordinate2D(latitude: 36.331800,longitude: 127.465545)
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

        let button1 = createButton(title: "   킥보드 주차장   ", tag: 1)
        let button2 = createButton(title: "   주차장   ", tag: 2)
        let button3 = createButton(title: "   편의점   ", tag: 3)
        let button4 = createButton(title: "   교내식당   ", tag: 4)
        let button5 = createButton(title: "   카페   ", tag: 5)
        let button6 = createButton(title: "   흡연구역   ", tag: 6)
        let button7 = createButton(title: "   건물번호   ", tag: 7)
        
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
        
        categoryStackView.addArrangedSubview(button1)
        categoryStackView.addArrangedSubview(button2)
        categoryStackView.addArrangedSubview(button3)
        categoryStackView.addArrangedSubview(button4)
        categoryStackView.addArrangedSubview(button5)
        categoryStackView.addArrangedSubview(button6)
        categoryStackView.addArrangedSubview(button7)
        
        // 카테고리 스택뷰를 스크롤뷰에 추가
        scrollView.addSubview(categoryStackView)
        
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            categoryStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            categoryStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        
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
    
    
    // 마커를 선택할 때 호출됨
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) {
        print("마커를 선택했습니다. 제목: \(marker.title ?? "")")
    }
    
    // 탭한 곳의 위도와 경도를 나타낼 수 있는 메소드
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("didTapAt \(coordinate.latitude), \(coordinate.longitude)")
        
//        self.addMarker(latitude: coordinate.latitude, longitude: coordinate.longitude, title: "title", buttonTag: 1203213) // 마커를 추가
    }
    
    
    
//   - (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        print("didLongPressAt \(coordinate.latitude), \(coordinate.longitude)")
        
//        self.addMarker(latitude: coordinate.latitude, longitude: coordinate.longitude, title: "title", buttonTag: 1203213) // 마커를 추가
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print("didTapInfoWindowOf \(marker.title)")
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf \(String(describing: marker.title))")
        
        if let location_title = marker.title{
                    if let resMapDetailVC = storyboard?.instantiateViewController(withIdentifier: "ResMapdetailViewController") as? ResMapdetailViewController {

                        resMapDetailVC.categoryName = categoryTitle
                        resMapDetailVC.Atitle = location_title
                        resMapDetailVC.cam = "교내 편의시설"

                        //모달 표시
                        present(resMapDetailVC, animated: true, completion: nil)
                    }
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
        case 1: // 킥보드 주차장
            addFirebasePins(categoryName: "킥보드 주차장")
            categoryTitle="킥보드 주차장"
        case 2: // 주차장
            addFirebasePins(categoryName: "주차장")
            categoryTitle="주차장"
        case 3: // 편의점
            addFirebasePins(categoryName: "편의점")
            categoryTitle="편의점"
        case 4: // 교내식당
            addFirebasePins(categoryName: "교내식당")
            categoryTitle="교내식당"
        case 5: // 카페
            addFirebasePins(categoryName: "카페")
            categoryTitle="카페"
        case 6: // 흡연구역
            addFirebasePins(categoryName: "흡연구역")
            categoryTitle="흡연구역"
        case 7: // 학교 건물번호
            addFirebasePins(categoryName: "학교 건물번호")
            categoryTitle="학교 건물번호"
        default:
            break
        }
    }
    
    
    // 마커 추가
    func addMarker(latitude: Double, longitude: Double, title: String, buttonTag: Int) {
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
        // Firebase 데이터베이스에서 "교내 편의시설" 위치의 데이터를 가져옵니다.
        ref.child("교내 편의시설").child(categoryName).observe(.value) { (snapshot) in
            for child in snapshot.children {
                if let pinSnapshot = child as? DataSnapshot,
                    let pinData = pinSnapshot.value as? [String: Any],
                    let latitude = pinData["latitude"] as? Double,
                    let longitude = pinData["longitude"] as? Double,
                    let title = pinData["title"] as? String,
                    let tag = pinData["tag"] as? Int {
                    self.addMarker(latitude: latitude, longitude: longitude, title: title, buttonTag: tag) // 마커를 추가
                }
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
