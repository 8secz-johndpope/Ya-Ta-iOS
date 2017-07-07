//
//  ProfileResultData.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 3..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProfileResultMother: Mappable {
    var result = [ProfileResultData]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        result <- map["result"]
    }
}

struct ProfileResultData: Mappable {
    var user_id = ""
    var user_name = ""
    var user_email = ""
    var user_phone = ""
    var user_insure = ""
    var user_image: String? = nil
    var user_type = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        user_id <- map["user_id"]
        user_name <- map["user_name"]
        user_email <- map["user_email"]
        user_phone <- map["user_phone"]
        user_insure <- map["user_insure"]
        user_image <- map["user_image"]
        user_type <- map["user_type"]
    }
}
