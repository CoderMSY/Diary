//
//  FBDiaryAddToolBar.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/27.
//

import UIKit

protocol FBDiaryAddToolBarProtocol {
    func diaryAddToolBarBtnItemClicked(_ diaryAddToolBar: FBDiaryAddToolBar, systemItem: UIBarButtonItem.SystemItem) ->()
}

class FBDiaryAddToolBar: UIToolbar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createItems() {
        let itemTypeArr: [UIBarButtonItem.SystemItem] = [
            .trash,
            .flexibleSpace,
            .search,
            .flexibleSpace,
            .camera,
            .flexibleSpace,
            .add,
            .flexibleSpace,
            .compose,

        ]
        var itemList: [UIBarButtonItem] = []
        
        for type in itemTypeArr {
            
            let btnItem = UIBarButtonItem(barButtonSystemItem: type, target: self, action: #selector(btnItemClicked(_:)))
            btnItem.tag = 1000 + type.rawValue
            
//            if type == UIBarButtonItem.SystemItem.flexibleSpace {
//                btnItem.width = 50.0
//            }
            
            itemList.append(btnItem)
        }
        
        self.items = itemList
    }
}

extension FBDiaryAddToolBar {
    @objc private func btnItemClicked(_ sender: UIBarButtonItem) {
        switch sender.tag - 1000 {
        case UIBarButtonItem.SystemItem.camera.rawValue:
            let ctr = fb_viewController()
            guard let ctr = ctr else {
                return
            }
            (ctr as! FBDiaryAddViewController).diaryAddToolBarBtnItemClicked(self, systemItem: .camera)
            print("添加photo")
        default:
            print(sender.tag)
        }
    }
}
