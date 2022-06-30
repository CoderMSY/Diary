//
//  UIViewFBExtension.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/29.
//

import UIKit

extension UIView {
    func fb_viewController() -> UIViewController? {
        var current = next
        while current != nil {
            if current is UIViewController {
                return current as? UIViewController
            }
            
            current = current?.next
        }
        
        return nil
    }
}
