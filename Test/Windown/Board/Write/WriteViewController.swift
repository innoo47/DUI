//
//  WriteViewController.swift
//  Test
//
//  Created by 박인호 on 10/30/23.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class WriteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var btnDone: UIBarButtonItem!    // 등록 버튼
    @IBOutlet weak var txTitle: UITextField!        // 제목 필드
    @IBOutlet weak var txMessage: UITextView!       // 내용 필드
    
    var ref: DatabaseReference!
    
    var textTitle: String = ""      // 제목
    var textMessage: String = ""    // 내용
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Firebase Database Reference 가져오기
        ref = Database.database().reference()
        
        // 제목 필드의 키보드 상호작용 처리
        txTitle.delegate = self
        // 내용 필드의 키보드 상호작용 처리
        txMessage.delegate = self
        
        // 제목 필드의 테두리 스타일 설정
        txTitle.layer.borderWidth = 1.0 // 테두리 두께
        txTitle.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
        txTitle.layer.cornerRadius = 5.0 // 테두리 모서리 반경
        
        // 내용 필드의 테두리 스타일 설정
        txMessage.layer.borderWidth = 1.0 // 테두리 두께
        txMessage.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
        txMessage.layer.cornerRadius = 5.0 // 테두리 모서리 반경

    }
    
    // 작성 버튼
    @IBAction func btnDone(_ sender: Any) {
        
        // 문자열 변수에 저장
        textTitle = txTitle.text ?? ""
        textMessage = txMessage.text ?? ""
        
        var columNm: String = ""
        
        let currentTime = CommonUtil.getCurrentTime(dateFormat: Define.BOARD_REG_DATE_TYPE)
        columNm = currentTime
        
        if let uuid = AppStorage.sharedInstance.getUUID(), !textTitle.isEmpty, !textMessage.isEmpty {
        
//            columNm = "\(uuid)\(currentTime)"
            columNm = uuid + currentTime
            
            let dateTemp = ["UID": uuid, "title": textTitle, "context": textMessage, "regDate": currentTime]
            
            print("작성완료 : ", dateTemp)
            print("Board ID : ", columNm)
            
            self.ref.child("게시판").child(columNm).setValue(dateTemp)
            
            let alertController = UIAlertController(title: "작성 완료", message: "게시물 작성에 성공했습니다.", preferredStyle: .alert)

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
            
        } else {
            // 변수가 nil 또는 빈 경우 처리
            print("게시물 작성 실패")
            let alertController = UIAlertController(title: "실패", message: "게시물 작성에 실패했습니다.", preferredStyle: .alert)

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
    
    // UITextFieldDelegate 메서드를 사용하여 글자 수 제한을 설정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 30 // 원하는 글자 수 제한을 설정
    }
    
    // UITextViewDelegate 메서드를 사용하여 글자 수 제한을 설정
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        let currentText = textView.text
        if let textRange = Range(range, in: currentText!) {
            let newText = currentText!.replacingCharacters(in: textRange, with: text)
            return newText.count <= 800 // 원하는 글자 수 제한을 설정
        }
        return true
    }
    
    // Return키를 누를 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Return 키를 누르면 키보드를 내림
        return true
    }

    // 빈 공간을 탭시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // 다른 화면 영역을 탭하면 키보드를 내림
    }

   

}
