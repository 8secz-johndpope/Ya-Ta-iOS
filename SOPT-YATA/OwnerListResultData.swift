//
//  OwnerListResultData.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 7..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import ObjectMapper

struct OwnerListMotherResultData: Mappable {
    var result = [OwnerListResultData]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        result <- map["result"]
    }
}

struct OwnerListResultData: Mappable {
    var applying_idx = -1
    var matching_idx = -1
    var applying_created_at = ""
    var applying_message = ""
    var user_name = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        applying_idx <- map["applying_idx"]
        matching_idx <- map["matching_idx"]
        applying_created_at <- map["applying_created_at"]
        applying_message <- map["applying_message"]
        user_name <- map["user_name"]
    }
}
