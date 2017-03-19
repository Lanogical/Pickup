//
//  APIRequests.swift
//  Pickup
//
//  Created by Ben Koska on 3/12/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

class APIRequests {
    static let baseurl = "http://news.cloudapp.net"
        
    static func logKid(_ name: String, callback: @escaping () -> Void) {
        let url = baseurl + "/picked/add"
        let headers: HTTPHeaders = [
            "name": name
        ]
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            if response.error != nil {
                APIRequests.logKid(name, callback: callback)
            }
            
            if let JSON = response.result.value {
                let dict = JSON as! [String: Any]
                if (dict["status"] as! Bool) == true {
                    callback()
                }
                    
                
            }
        }
    }
    static func loginWithToken(_ token: String, callback: @escaping (_ succes: Bool,_ rank: String) -> Void) {
        let url = baseurl + "/users/token/check"
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            if response.error != nil {
                APIRequests.loginWithToken(token, callback: callback)
            }
            
            if let JSON = response.result.value {
                let dict = JSON as! [String: Any]
                if (dict["succes"] as! Bool) == true {
                    print(dict)
                    callback(true, dict["rank"] as! String)
                }else{
                    callback(false, dict["rank"] as! String)
                }
            }
        }
    }
    static func removeKids(name: String) {
        let url = baseurl + "/picked/del"
        let headers: HTTPHeaders = [
            "name": name
        ]
        Alamofire.request(url, method: .post, headers: headers).responseJSON { (response) in
            
        }
    }
    static func pickedup(callback: @escaping (_ data: [[String: Any]]) -> Void) {
        let url = baseurl + "/picked/all"
        Alamofire.request(url, method: .post).responseJSON { response in
            if let JSON = response.result.value {
                let dict = JSON as! [[String: Any]]
                callback(dict)
            }
        }
    }
    
    static func login(_ email:String, pwd: String, callback: @escaping (_ data: [String: Any]) -> Void) {
        let url = baseurl + "/users/check"
        let headers: HTTPHeaders = [
            "email" : email,
            "password": pwd
        ]
        Alamofire.request(url, method: .post, headers: headers).responseJSON { response in
            if let JSON = response.result.value {
                APIRequests.handleLoginData(JSON, callback: callback)
            }
            
            
        }
    }
    
    static func handleLoginData(_ data: Any?,callback: @escaping (_ data: [String: Any]) -> Void) {
        let dict = data as! [String: Any]
        callback(dict)
    }
    
    static func getKids(callback: @escaping (_ data: [[String: String]]) -> Void) {
        let url = baseurl + "/kids/all"
        Alamofire.request(url, method: .post).responseJSON { response in
            if let JSON = response.result.value {
                APIRequests.handleKidsData(JSON, call: callback)
            }
        }
    }
    
    static func handleKidsData(_ data: Any?, call: @escaping (_ data: [[String: String]]) -> Void) {
        let dict = data as! [[String: String]]
        call(dict)
    }
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    static func getGroups(token: String, callback: @escaping (_ data: [[String: Any]]) -> Void) {
        let url = baseurl + "/group/find"
        let headers: HTTPHeaders = [
            "token" : token
        ]
        Alamofire.request(url, method: .post, headers: headers).responseJSON { response in
            if let JSON = response.result.value {
                let dict = JSON as! [[String: Any]]
                callback(dict)
            }
        }
    }
    
    static func createGroup (kids: String, name:String) {
        let token = UserDefaults.standard.string(forKey: LocalData.tokenKey)
        let url = baseurl + "/group/add"
        let headers: HTTPHeaders = [
            "token" : token!,
            "name": name,
            "kids": kids
        ]
        Alamofire.request(url, method: .post, headers: headers).responseJSON { response in }
    }
    
}
