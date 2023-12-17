//
//  ViewController.swift
//  GoogleMap
//
//  Created by 박인호 on 2023/08/23.
//

import UIKit
import GoogleMaps
import GooglePlaces


class dMyMapController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var jdjskl: UISearchBar!
    
    @IBAction func sdasdas(_ sender: UISegmentedControl) {
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: Define.LAT_001, longitude: Define.LONG_001, zoom: 17.3)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //mapView.isMyLocationEnabled = true
                view = mapView
        /*
        // 접근성
        mapView.accessibilityElementsHidden = true
          */
        
        // 내 위치 활성화 여부
        mapView.isMyLocationEnabled = true
        
        // 내 위치 이동 버튼 생성
        mapView.settings.myLocationButton = true
        
        // 나침반 생성
        mapView.settings.compassButton = true
        
        // 최대 줌 설정
        mapView.setMinZoom(17.3, maxZoom: 19)
        
        // 경계 설정
        let vancouver = CLLocationCoordinate2D(latitude: 36.338861, longitude: 127.457018)
        let calgary = CLLocationCoordinate2D(latitude: 36.331800,longitude: 127.465545)
        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
        let camera2 = mapView.camera(for: bounds, insets: UIEdgeInsets())!
        mapView.camera = camera2
              
        // 화면 이동을 특정 영역으로 제한
        mapView.cameraTargetBounds = bounds
        
            
        // 지도에 범위 제한선 만들기
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: 36.341526, longitude: 127.453016))
        path.add(CLLocationCoordinate2D(latitude: 36.327387, longitude: 127.453016))
        path.add(CLLocationCoordinate2D(latitude: 36.327387, longitude: 127.468481))
        path.add(CLLocationCoordinate2D(latitude: 36.341526, longitude: 127.468481))
        path.add(CLLocationCoordinate2D(latitude: 36.341526, longitude: 127.453016))
        let polyline = GMSPolyline(path: path)
              
        let rectanglePath = GMSMutablePath()
        rectanglePath.add(CLLocationCoordinate2D(latitude: 36.341526, longitude: 127.453016))
        rectanglePath.add(CLLocationCoordinate2D(latitude: 36.327387, longitude: 127.453016))
        rectanglePath.add(CLLocationCoordinate2D(latitude: 36.327387, longitude: 127.468481))
        rectanglePath.add(CLLocationCoordinate2D(latitude: 36.341526, longitude: 127.458481))
        rectanglePath.add(CLLocationCoordinate2D(latitude: 36.341526, longitude: 127.453016))
        let rectangle = GMSPolyline(path: path)
        rectangle.map = mapView
              
                // Creates a marker in the center of the map.
                let marker1 = GMSMarker()
                let marker2 = GMSMarker()
                let marker3 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 36.335988, longitude: 127.459917)
                marker1.title = "대전대학교"
                marker1.snippet = "대한민국"
                marker1.map = mapView
        marker2.position = CLLocationCoordinate2D(latitude: 36.334717, longitude: 127.456761)
                marker2.title = "대전대학교 서문 잔디광장"
                marker2.snippet = "대한민국"
                marker2.map = mapView
        marker3.position = CLLocationCoordinate2D(latitude: 36.333345, longitude: 127.456231)
                marker3.title = "용수골 어린이공원"
                marker3.snippet = "대한민국"
                marker3.map = mapView
            }
    
    
}



