//
//  ResMapdetailViewController.swift
//  Test
//
//  Created by 현수 on 11/10/23.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResMapdetailViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentTextFied: UITextField!
    
    var ref: DatabaseReference!
    var categoryName: String = "" // 카테고리 정보
    var Atitle: String = "" //
    var cam: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Database Reference 가져오기
        ref = Database.database().reference()
        
        // 제목 필드의 테두리 스타일 설정
        contentTextFied.layer.borderWidth = 1.0 // 테두리 두께
        contentTextFied.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
        contentTextFied.layer.cornerRadius = 5.0 // 테두리 모서리 반경
        contentTextFied.isEnabled = false  // 읽기 전용

                // 내용 필드의 테두리 스타일 설정
        contentTextView.layer.borderWidth = 1.0 // 테두리 두께
        contentTextView.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
        contentTextView.layer.cornerRadius = 5.0 // 테두리 모서리 반경
        contentTextView.isEditable = false // 읽기 전용
        
        // placeID가 존재하면 데이터를 가져와서 표시
          self.fetchPlaceDetails()
        
    }
    
    // Firebase에서 장소 정보 가져와 텍스트 뷰에 출력하는 함수
    func fetchPlaceDetails() {
        // Firebase 데이터베이스에서 placeID에 해당하는 장소의 정보를 가져옵니다.
        ref.child(cam).child(categoryName).child(Atitle).observe(.value) { (snapshot) in
            if let placeData = snapshot.value as? [String: Any],
               let title = placeData["title"] as? String,
               let content = placeData["content"] as? String {
                
                // 가져온 정보를 텍스트 뷰에 설정
                let Info = "\(content)"
                self.contentTextView.text = Info
                let PlaceName = "\(title)"
                self.contentTextFied.text = PlaceName
                
            }
            else { print("error")
                self.contentTextView.text = "Info가 포함되어 있지 않습니다."
                self.contentTextFied.text = "PlaceName이 포함되어 있지 않습니다."
            }
        }
    }
    

}
