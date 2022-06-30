//
//  FBBaseViewController.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/27.
//

import UIKit

class FBBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentClass:AnyClass! = object_getClass(self)
        let className = NSStringFromClass(currentClass)
        
        print("😄😄😄:\(className) - " + #function)
    }
    
    deinit {
        let currentClass:AnyClass! = object_getClass(self)
        let className = NSStringFromClass(currentClass)
        
        print("😂😂😂:\(className) - " + #function)
    }

    func createCloseItem() {
        let closeItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissPage(_:)))
        navigationItem.leftBarButtonItem = closeItem
    }
    
    @objc func dismissPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
