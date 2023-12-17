//
//  ShowViewController.swift
//  Test
//
//  Created by 박인호 on 11/2/23.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

struct ShowBoard {
    var sUID: String = ""
    var sTitle: String = ""
    var sContext: String = ""
    var sRegDate: String = ""
}

class ShowViewController: UIViewController {
    
    
    @IBOutlet weak var txViewTitle: UITextField!
    @IBOutlet weak var txViewMessage: UITextView!
    
    var ref: DatabaseReference!
    
    var boardID: String = ""
    var UUID: String = ""
    var aUID: String = ""
    
    var uuid = AppStorage.sharedInstance.getUUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Database Reference 가져오기
        self.ref = Database.database().reference()
        
        // 제목 필드의 테두리 스타일 설정
        txViewTitle.layer.borderWidth = 1.0 // 테두리 두께
        txViewTitle.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
        txViewTitle.layer.cornerRadius = 5.0 // 테두리 모서리 반경
        txViewTitle.isEnabled = false  // 읽기 전용

        // 내용 필드의 테두리 스타일 설정
        txViewMessage.layer.borderWidth = 1.0 // 테두리 두께
        txViewMessage.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
        txViewMessage.layer.cornerRadius = 5.0 // 테두리 모서리 반경
        txViewMessage.isEditable = false // 읽기 전용
        
        // Firebase 데이터 가져오기
        self.ShowFirebaseBoard(ID: boardID)
        
        // 삭제 버튼 생성
        let DeleteBarButtonItem = UIBarButtonItem(
            title: "삭제",
            style: .plain,
            target: self,
            action: #selector(DeleteBarButtonTapped)
        )
               
        // 네비게이션 바 오른쪽에 버튼 추가
        navigationItem.rightBarButtonItem = DeleteBarButtonItem
    
    }
    
    // Firebase에서 데이터를 가져오는 메소드
    func ShowFirebaseBoard(ID: String) {
        self.ref.child("게시판").child(ID).observe(.value) { (snapshot) in

            print("---------")
            print("id : \(ID)")
            print("ref : \(String(describing: self.ref.child("게시판")))")

            if let data = snapshot.value as? [String: Any],
               let UID = data["UID"] as? String,
               let title = data["title"] as? String,
               let context = data["context"] as? String,
               let regDate = data["regDate"] as? String {

                var abc = ShowBoard.init()
                abc.sUID = UID
                abc.sTitle = title
                abc.sContext = context
                abc.sRegDate = regDate
                
                print("UID : \(abc.sUID)")
                print("Title : \(abc.sTitle)")
                print("Context : \(abc.sContext)")
                print("regDate : \(abc.sRegDate)")
                
                self.UUID = abc.sUID

                // UI 업데이트
                self.txViewTitle.text = abc.sTitle
                self.txViewMessage.text = abc.sContext
                
            } 
//            else {
//                print("Error: Data extraction failed")
//            }
        }
    }

    @objc func DeleteBarButtonTapped() {
        
        print("---------")
        var abc = ShowBoard.init()
        let uuid = AppStorage.sharedInstance.getUUID()
        self.aUID = uuid!
        
        print("Your UID : \(aUID)")
        print("App UID : \(self.UUID)")
        
        if aUID == self.UUID {
            self.ref.child("게시판").child(boardID).removeValue { error, _ in
                if let error = error {
                    print("게시물 삭제에 실패했습니다: \(error.localizedDescription)")
                } else {
                    print("게시물이 성공적으로 삭제되었습니다.")
                    let alertController = UIAlertController(title: "삭제", message: "게시물이 성공적으로 삭제되었습니다.", preferredStyle: .alert)

                            // 확인 버튼 추가
                            let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
                                // 확인 버튼이 눌렸을 때 수행할 동작
                                print("확인 버튼이 눌렸습니다.")
                                // 버튼을 누르면 초기화면으로 복귀
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                            alertController.addAction(okAction)

                            // 경고 팝업 표시
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        } else {
            print("게시물 삭제 불가")
            let alertController = UIAlertController(title: "실패", message: "게시물을 삭제할 권한이 없습니다.", preferredStyle: .alert)

                    // 확인 버튼 추가
                    let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
                        // 확인 버튼이 눌렸을 때 수행할 동작
                        print("확인 버튼이 눌렸습니다.")
                    }
                    alertController.addAction(okAction)

                    // 경고 팝업 표시
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
