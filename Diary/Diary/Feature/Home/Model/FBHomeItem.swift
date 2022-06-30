//
//  FBHomeItem.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/24.
//

import Foundation
import HandyJSON

struct FBHomeItem: HandyJSON {
//    init() {
//        
//    }
    
    var title: String = ""
    var detail: String = ""
    var timestamp: Double = 0
    var imageEncodedStr: String = ""
}
