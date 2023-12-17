//
//  AppStorage.swift
//  Test
//
//  Created by 현수 on 10/29/23.
//

import UIKit

class AppStorage {
    
    static let MAKE_UUID    = "MAKE_UUID"
    
    static let sharedInstance : AppStorage = {
        
        let instance = AppStorage()
        
        //setup code
        
        return instance
        
    }()
    
    
    // MARK: UUID
    func setUUID( uuid: String? ) -> Void {
        
        self.writeStr(value: uuid, strKey: AppStorage.MAKE_UUID)
    }
    
    func getUUID() -> String?{
        
        return self.readStr(strKey: AppStorage.MAKE_UUID)
    }
    
}

extension AppStorage{
    
    func readStr(strKey:String)->String?{
        
        let defaults = UserDefaults.standard
        let pData:String? = defaults.object(forKey: strKey) as? String
        
        if let str = pData {
            
            return str
        }else{
        
            return pData
        }
        
    }
    
    
    func writeStr(value:String?, strKey:String)->Void{
         
        let defaults = UserDefaults.standard
        if let val = value{
            
            defaults.set(val, forKey: strKey)
        }
        else{
            
            defaults.set(nil, forKey: strKey)
        }
        defaults.synchronize()
    }
}


