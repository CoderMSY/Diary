//
//  FBHomeViewController.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/24.
//

import UIKit
import SnapKit
import SwiftyJSON

class FBHomeViewController: UIViewController {

    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain);
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(FBHomeCell.self, forCellReuseIdentifier: FBHomeCell.cellReuseId)
        return tableView
    }()
    
    var dataSource: [FBHomeItemFrame] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        createNavItem()
        initSubviews()
        
        getLocalData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    

}

extension FBHomeViewController {
    private func initSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView);
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func createNavItem() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemClicked(_:)))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc private func addItemClicked(_ sender: UIBarButtonItem) {
        let ctr = FBDiaryAddViewController()
        ctr.addItemCallback { item in
            let itemFrame = FBHomeItemFrame(homeItem: item)
            self.dataSource.append(itemFrame)
            
            let indexPath = IndexPath(row: self.dataSource.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            let jsonMap = item.toJSON()
            guard let jsonMap = jsonMap else { return }
            
            let json = JSON(jsonMap)
            FBDaoFactory.sharedInstance.insert(item: json)
        }
        navigationController?.pushViewController(ctr, animated: true)
    }
    
    private func getLocalData() {
        let rowList = FBDaoFactory.sharedInstance.search()
        print(rowList)
        
        var modelList: [FBHomeItemFrame] = []
        rowList.forEach { row in
            let item = FBHomeItem(title: row[column_title],
                                  detail: row[column_detail],
                                  timestamp: row[column_timestamp],
                                  imageEncodedStr: row[column_imageEncodedStr])
            
            let itemFrame = FBHomeItemFrame(homeItem: item)
            modelList.append(itemFrame)
        }
        
        dataSource = modelList
        tableView.reloadData()
        
//        FBDaoFactory.sharedInstance.search(select: [column_title], order: <#T##[Expressible]#>, filter: nil, limit: 5, offset: nil)
    }
}

extension FBHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FBHomeCell.cellReuseId) as! FBHomeCell

        let itemFrame = dataSource[indexPath.row]
        cell.itemFrame = itemFrame

        return cell
    }
}

extension FBHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemFrame = dataSource[indexPath.row]
        
        return itemFrame.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
