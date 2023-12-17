//
//  ViewController.swift
//  GoogleMap
//
//  Created by 박인호 on 2023/08/23.
//

import UIKit
import GoogleMaps
import GooglePlaces




class MapViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    @IBOutlet weak var googleVC: UIView!
    
    
    // 카페 버튼
    @IBAction func nearCafe(_ sender: UIButton) {
        
        // MyMapController의 인스턴스를 생성
        let googleMapVC = MapController()
        
        
        
        // 값을 전달
        //googleMapVC.receivedValue = 1
        
        
        //self.view.setNeedsLayout()
        //self.googleVC.layoutIfNeeded()

        
        // MyMapController를 모달로 표시 -> 핀이 정상적으로 표시 -> 데이터는 전달이 되지만 UIView의 지도는 버튼을 누르기 전의 상황을 표시 -> 지도를 새로 로드한다면 핀이 나타날 것으로 보임
        //self.present(googleMapVC, animated: false, completion: nil)
        
        
    }
    
    
  
}
    
    
    
    
    
        
        
    
    
    
    



