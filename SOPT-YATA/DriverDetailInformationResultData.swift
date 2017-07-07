//
//  DriverDetailInformationResultData.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 7..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import ObjectMapper

struct DriverDetailInformationMotherResultData: Mappable {
    var result = [DriverDetailInformationResultData]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        result <- map["result"]
    }
}

struct DriverDetailInformationResultData: Mappable {
    var applying_idx = -1
    var rating_star = -1
    var applying_message = ""
    var user_name = ""
    var user_age = -1
    var user_career = ""
    var applying_companion = -1
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        applying_idx <- map["applying_idx"]
        rating_star <- map["rating_star"]
        applying_message <- map["applying_message"]
        user_name <- map["user_name"]
        user_age <- map["user_age"]
        user_career <- map["user_career"]
        applying_companion <- map["applying_companion"]
    }
}
