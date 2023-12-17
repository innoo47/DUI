//
//  CommonUtil.swift
//  Test
//
//  Created by 현수 on 10/29/23.
//
import UIKit
class CommonUtil: NSObject {
    
    static let DATE_FORMAT_YYYYMMDDHHMMSS : String = "yyyyMMddHHmmss"
    
    static func getKorDateFormatter ( dateFormat : String ) -> DateFormatter {
        
        let date = DateFormatter()
        
        date.locale = Locale(identifier: "ko_KR")
        date.timeZone = TimeZone(abbreviation: "KST")
        date.dateFormat = dateFormat  // yyyyMMddHHmm, "yyyy-MM-dd HH:mm:ss EEEE"
        
        return date
    }
    
    static func getCurrentTime ( dateFormat : String ) -> String {
        
        let now = Date()
        let dateFormatter = self.getKorDateFormatter( dateFormat: dateFormat )
        
        let currentTime = dateFormatter.string(from: now)
        
        return currentTime
    }
    
    static func isNull(_ obj:Any?) -> Bool{
        
        if let p_obj = obj {
            
            if p_obj is String, let str = p_obj as? String{
                
                if str.count == 0 || str == ""{
                    
                    return true
                }
                else{
                    
                    return false
                }
            }
            else{
                
                return false
            }
        }
        else{
            
            return true
        }
    }
    
    static func getDateDuration(_ inputDate:String) -> String? {
         
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Define.BOARD_REG_DATE_TYPE
 
        var returnDay = "0"
        if let specificDate = dateFormatter.date(from: inputDate) {
            // 3. 현재 시간을 가져옵니다.
            let currentDate = Date()
            
            // 4. 특정 날짜와 현재 날짜 간의 차이를 계산합니다.
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day, .hour, .minute], from: specificDate, to: currentDate)
            
            if let daysAgo = components.day, 
                let hoursAgo = components.hour,
                let minuteAgo = components.minute {
                if daysAgo < 0 {
                    
                    return "0"
                } else {
                    if daysAgo > 0 {
                        print("\(inputDate)로부터 \(daysAgo)일 전")
                        returnDay = "\(daysAgo)일 전"
                    }
                    else{
                        
                        if hoursAgo > 0 {
                            print("\(inputDate)로부터 \(hoursAgo)시간 전")
                            returnDay = "\(hoursAgo)시간 전"
                        }
                        else{
                            print("\(inputDate)로부터 \(minuteAgo)분 전")
                            returnDay = "\(minuteAgo)분 전"
                        }
                    }
                }
            } else {
                print("날짜 계산 오류")
                returnDay = "날짜 계산 오류"
            }
        } else {
            print("날짜 변환 오류")
            returnDay = "날짜 변환 오류"
        }
        return returnDay
    }
}
