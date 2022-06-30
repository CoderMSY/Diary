//
//  FBDiaryAddView.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/27.
//

import UIKit
import SnapKit

protocol FBDiaryAddViewDelegate {
    func diaryAddViewDidChange(_ titleTextView: UITextView) ->()
}

class FBDiaryAddView: UIView {

    var delegate: FBDiaryAddViewDelegate?
    
    lazy var photoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        
        
        return imageView
    }()
    lazy var titleTextView: UITextView = {
        var textView = UITextView()
        textView.isEditable = true
//        textView.textColor =
        
        return textView
    }()
    
    lazy var detailTextView: UITextView = {
        var textView = UITextView()
//        textView
        return textView
    }()
    
    lazy var toolBar: FBDiaryAddToolBar = {
        var toolBar = FBDiaryAddToolBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
        
        return toolBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initSubview() {
        titleTextView.delegate = self
        detailTextView.delegate = self
        
        addSubview(photoImageView)
        addSubview(titleTextView)
        addSubview(detailTextView)
        addSubview(toolBar)
        
        let imageView_h = UIScreen.main.bounds.size.width * 9.0 / 16.0
        photoImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView_h)
        }
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(80.0)
        }
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(toolBar.snp.top)
//            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        toolBar.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(44.0)
        }
        
    }
}

extension FBDiaryAddView {

}

extension FBDiaryAddView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        print("text: \(String(describing: textView.text))")
        if (textView.isEqual(titleTextView)) {
            delegate?.diaryAddViewDidChange(textView)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        //
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y < 0 && decelerate) {
            
        }
    }
}
