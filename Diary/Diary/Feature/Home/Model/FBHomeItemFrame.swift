//
//  FBHomeItemFrame.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/29.
//

import Foundation
import UIKit

let kHomeCell_margin: CGFloat = 15.0
let kHomeCellImage_h: CGFloat = 120.0

struct FBHomeItemFrame {
    let titleFont: UIFont = UIFont.systemFont(ofSize: 17.0)
    let detailFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    let dateFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    
    var dateStr: String = ""
    var cellHeight: CGFloat = 0
    var image: UIImage?
    var image_height: CGFloat = 0.0
    
    init(homeItem: FBHomeItem) {
        self.homeItem = homeItem
        
        updateData()
    }
    
    var homeItem: FBHomeItem
//    {
//        didSet {
//            updateData(homeItem: homeItem)
//        }
//    }
    
    
    private mutating func updateData() {
        let maxWidth = UIScreen.main.bounds.size.width - kHomeCell_margin * 4
        
        cellHeight += kHomeCell_margin * 3
        
        cellHeight += (homeItem.title as NSString).boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).height
        
        if homeItem.detail.count > 0 {
            cellHeight += kHomeCell_margin
            cellHeight += (homeItem.detail as NSString).boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: detailFont], context: nil).height
        }
        
        
        
        if homeItem.imageEncodedStr.count > 0 {
            let imageData = Data(base64Encoded: homeItem.imageEncodedStr)
            if let imageData = imageData {
                image = UIImage(data: imageData)
                
                if let size = image?.size {
                    image_height = maxWidth * size.height / size.width
                    
                } else {
                    image_height = kHomeCellImage_h
                }
                
                cellHeight += kHomeCell_margin
                cellHeight += image_height
            }
        } else {

        }
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = Date(timeIntervalSince1970: homeItem.timestamp)
        dateStr = dateFormatter.string(from: date)
        cellHeight += kHomeCell_margin
        cellHeight += (dateStr as NSString).boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: dateFont], context: nil).height
        cellHeight += kHomeCell_margin
    }
}
