//
//  LoginResultData.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import ObjectMapper

struct LoginResultData: Mappable {
    var status = false
    var message = ""
    var result: LoginData? = nil
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        result <- map["result"]
    }
    
}

struct LoginData: Mappable {
    var token = ""
    var profile: LoginProfile? = nil
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        token <- map["token"]
        profile <- map["profile"]
    }
}

struct LoginProfile: Mappable {
    var id = ""
    var username = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
    }
}
