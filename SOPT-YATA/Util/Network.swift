//
//  Network.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire
import AlamofireObjectMapper

public class Network {
    private let baseUrl = "http://52.78.25.56:3000/api"
    private let userDefault = UserDefaults.standard
    
    func postJoin(_ data: JoinData, completionHandlers: @escaping (_ result: Bool, _ data: JoinResultData?) -> Void)  {
        let inputUrl = "\(baseUrl)/user/register"
        let parameters: Parameters = ["id" : data.id,
                                      "pw1" : data.password,
                                      "pw2" : data.confirmPassword,
                                      "email": data.email,
                                      "name": data.username,
                                      "phone": data.phoneNumber]
        Alamofire.request(inputUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<JoinResultData>) in
            switch response.result {
            case .success(let value):
                completionHandlers(true, value)
            case .failure(let error):
                debugPrint(error)
                completionHandlers(false, nil)
            }
        }
    }
    
    func postLogin(_ id: String, password: String, completionHandlers: @escaping (_ result: Bool, _ data: LoginResultData?) -> Void) {
        let inputUrl = "\(baseUrl)/user/login"
        let parameters: Parameters = ["id" : id,
                                      "pw" : password]
        
        Alamofire.request(inputUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<LoginResultData>) in
                switch response.result {
                case .success(let value):
                    completionHandlers(true, value)
                case .failure(let error):
                    debugPrint(error)
                    completionHandlers(false, nil)
                }
        }
    }
    
    func getUserProfile(completionHandlers: @escaping (_ result: Bool, _ data: ProfileResultData?) -> Void) {
        let inputUrl = "\(baseUrl)/profile"
        let headers: HTTPHeaders = ["token": userDefault.string(forKey: "token") ?? ""]
        
        Alamofire.request(inputUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseObject { (response: DataResponse<ProfileResultData>) in
                switch response.result {
                case .success(let value):
                    print(value)
                    completionHandlers(true, value)
                case .failure(let error):
                    debugPrint(error)
                    completionHandlers(false, nil)
                }
        }
    }
    
    func postOwnerMatching(time: String, firstPin: MKPlacemark, secondPin: MKPlacemark, with: Int, message: String,
                            completionHandlers: @escaping (_ result: Bool, _ data: JoinResultData?) -> Void) {
        let inputUrl = "\(baseUrl)/owner/match/register"
        
        let firstLocArr = firstPin.title?.components(separatedBy: " ")
        var firstLocTitle = ""

        if let firstLocArr = firstLocArr {
            if firstLocArr.count > 2 {
                firstLocTitle = firstLocArr[2]
            }
        }
        
        let secondLocArr = secondPin.title?.components(separatedBy: " ")
        var secondLocTitle = ""
        
        if let secondLocArr = secondLocArr {
            if secondLocArr.count > 2 {
                secondLocTitle = secondLocArr[2]
            }
        }
        
        let parameters: Parameters = ["slat": firstPin.coordinate.latitude,
                                      "slng": firstPin.coordinate.longitude,
                                      "elat": secondPin.coordinate.latitude,
                                      "elng": secondPin.coordinate.longitude,
                                      "companion": with,
                                      "time": time,
                                      "message": message,
                                      "sloc": firstLocTitle,
                                      "eloc": secondLocTitle,
                                      "saddr" : firstPin.title ?? "",
                                      "eaddr" : secondPin.title ?? ""]
        let headers: HTTPHeaders = ["token": userDefault.string(forKey: "token") ?? ""]
        
        Alamofire.request(inputUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseObject { (response: DataResponse<JoinResultData>) in
                switch response.result {
                case .success(let value):
                    completionHandlers(true, value)
                case .failure(let error):
                    debugPrint(error)
                    completionHandlers(false, nil)
                }
        }
    }
    
    func deleteOwnerMatching(completionHandlers: @escaping (_ result: Bool) -> Void) {
        let inputUrl = "\(baseUrl)/owner/match/register"
        let headers: HTTPHeaders = ["token": userDefault.string(forKey: "token") ?? ""]

        Alamofire.request(inputUrl, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON { (response) in
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if JSON["message"] as! String == "success" {
                        completionHandlers(true)
                    } else {
                        completionHandlers(false)
                    }
                } else {
                    completionHandlers(false)
                }
        }
    }
    
    func getOwnerMatchingList(completionHandlers: @escaping (_ result: Bool, _ data: OwnerListMotherResultData?) -> Void) {
        let inputUrl = "\(baseUrl)/owner/match/list/\(userDefault.integer(forKey: "matching_idx"))"
        let headers: HTTPHeaders = ["token": userDefault.string(forKey: "token") ?? ""]

        print(inputUrl)
        
        Alamofire.request(inputUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseObject { (response: DataResponse<OwnerListMotherResultData>) in
                switch response.result {
                case .success(let value):
                    completionHandlers(true, value)
                case .failure(let error):
                    debugPrint(error)
                    completionHandlers(false, nil)
                }
        }
    }
    
    func getDriverDetail(_ index: Int, completionHandlers: @escaping (_ result: Bool, _ data: DriverDetailInformationResultData?) -> Void) {
        let inputUrl = "\(baseUrl)/owner/match/detail/\(index)"
        let headers: HTTPHeaders = ["token": userDefault.string(forKey: "token") ?? ""]
        Alamofire.request(inputUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseObject { (response: DataResponse<DriverDetailInformationMotherResultData>) in
                switch response.result {
                case .success(let value):
                    completionHandlers(true, value.result[0])
                case .failure(let error):
                    debugPrint(error)
                    completionHandlers(false, nil)
                }
        }
    }
    
    func putMatchingApprove(_ index: Int, completionHandlers: @escaping (_ result: Bool) -> Void) {
        let inputUrl = "\(baseUrl)/owner/match/approve/\(index)"
        let headers: HTTPHeaders = ["token": userDefault.string(forKey: "token") ?? ""]

        Alamofire.request(inputUrl, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON { (response) in
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if JSON["message"] as! String == "success" {
                        completionHandlers(true)
                    } else {
                        completionHandlers(false)
                    }
                } else {
                    completionHandlers(false)
                }
        }
    }
    
    func putMatchingComplete(_ index: Int, completionHandlers: @escaping (_ result: Bool) -> Void) {
        let inputUrl = "\(baseUrl)/owner/match/complete/\(index)"
        let headers: HTTPHeaders = ["token": userDefault.string(forKey: "token") ?? ""]
        
        Alamofire.request(inputUrl, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON { (response) in
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if JSON["message"] as! String == "success" {
                        completionHandlers(true)
                    } else {
                        completionHandlers(false)
                    }
                } else {
                    completionHandlers(false)
                }
        }
    }

}
