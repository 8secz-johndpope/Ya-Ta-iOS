//
//  JoinResultData.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import ObjectMapper

struct JoinResultData: Mappable {
    var message = ""
    var status = false
    var result: MatchingData? = nil
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        result <- map["result"]
    }
}

struct MatchingData: Mappable {
    var matching_idx = 0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        matching_idx <- map["matching_idx"]
    }
}
