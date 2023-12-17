//
//  AppDelegate.swift
//  Test
//
//  Created by 박인호 on 2023/08/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseCore
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var DeviceUUID: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(Define.GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(Define.GOOGLE_API_KEY)
        FirebaseApp.configure()
        
        if let uuid = self.uuid(){
         
            print("UUID MAKE - [\(uuid)]")
        }
        else{
            
            print("UUID MAKE FAIL")
        }
        
        return true
    }
    
    // 디바이스의 UUID를 가져오는 메소드 ( 앱 삭제시 변경 됨 )
    func getDeviceUUID() -> String? {
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            return identifierForVendor.uuidString
        }
        return nil
    }
    
    // uuid = Device UUID + Current Time
    func uuid() -> String?{
        
        if let uuid = AppStorage.sharedInstance.getUUID(){
            
            print("uuid : \(uuid)")
            return uuid
        }
        else{

            // UUID 가져오기
            if let deviceUUID = getDeviceUUID() {
                print("기기 UUID: \(deviceUUID)")
                self.DeviceUUID = deviceUUID
            } else {
                print("기기 UUID를 가져올 수 없습니다.")
            }
            
            let currentTime = CommonUtil.getCurrentTime(dateFormat: CommonUtil.DATE_FORMAT_YYYYMMDDHHMMSS)
            
            if CommonUtil.isNull(currentTime){
                
                return nil
            }
            
            let plainUUID = "\(DeviceUUID)_\(currentTime)"
            print("plainUUID : \(plainUUID)")
            
            if CommonUtil.isNull(plainUUID){
                
                return nil
            }
            
            AppStorage.sharedInstance.setUUID(uuid: plainUUID)
            return plainUUID
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

