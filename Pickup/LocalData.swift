//
//  LocalData.swift
//  Pickup
//
//  Created by Ben Koska on 3/14/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import Foundation

class LocalData {
    static var loginDataArrived: Bool? {
        get {
            if let returnValue = UserDefaults.standard.object(forKey: "loginDataArrived") as? Bool {
                return returnValue
            }else{
                return nil
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "loginDataArrived")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var loginResponse: [String: Any]? {
        get {
            if let returnValue = UserDefaults.standard.object(forKey: "loginResponse") as? [String: Any] {
                return returnValue
            }else{
                return nil
            }
            
            
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "loginResponse")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var token: Any? {
        get {
            if let returnValue = UserDefaults.standard.object(forKey: "token") as? [String: Any] {
                return returnValue
            }else{
                return nil
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var tokenKey = "accountToken"
}
