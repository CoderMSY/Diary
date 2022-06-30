//
//  FBDaoFactory.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/27.
//

import Foundation
import SQLite
import SwiftyJSON

let column_title = Expression<String>("title")
let column_detail = Expression<String>("detail")
let column_timestamp = Expression<Double>("timestamp")
let column_imageEncodedStr = Expression<String>("imageEncodedStr")


class FBDaoFactory: NSObject {
    static let sharedInstance = FBDaoFactory()
    
    private var db: Connection?
    private var table: Table?
    override init() {
        super.init()
    }
    
    func getDB() -> Connection {
        guard let db = db else {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try! Connection("\(path)/db.sqlite3")
            db?.busyTimeout = 5.0
            return db!
        }
        
        return db
    }
    
    func getTable() -> Table {
        if table == nil {
            table = Table("records")
            try! getDB().run(
                table!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { builder in
                    builder.column(column_title)
                    builder.column(column_detail)
                    builder.column(column_timestamp)
                    builder.column(column_imageEncodedStr)
                })
            )
        }
        
        return table!
    }
    
    func insert(item: JSON) {
        let insert = getTable().insert(column_title <- item["title"].stringValue,
                                       column_detail <- item["detail"].stringValue,
                                       column_timestamp <- item["timestamp"].doubleValue,
                                       column_imageEncodedStr <- item["imageEncodedStr"].stringValue)
        if let rowId = try? getDB().run(insert) {
            debugPrint("插入成功:\(rowId)")
        } else {
            debugPrint("插入失败")
        }
    }
    func delete(item: JSON) {
        //
    }
    func search(select: [Expressible] = [rowid, column_title, column_detail, column_timestamp, column_imageEncodedStr],
                order: [Expressible] = [],
                filter: Expression<Bool>? = nil,
                limit: Int? = nil,
                offset: Int? = nil) -> [Row] {
        var query = getTable().select(select).order(order)
        if let filter = filter {
            query = query.filter(filter)
        }
        
        if let limit = limit {
            if let offset = offset {
                query = query.limit(limit, offset: offset)
            } else {
                query = query.limit(limit)
            }
        }
        
        let result = try! getDB().prepare(query)
        
        return Array(result)
    }
}

extension FBDaoFactory {
//    private func decodeData(rowList: AnySequence<Row>, completion: @escaping((_ datas: [String]) -> Void)) {
//        rowList.forEach { row in
//            let content: String = row.de
//        }
//    }
}
