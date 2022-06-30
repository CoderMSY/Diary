//
//  FBHomeCell.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/24.
//

import UIKit
import SnapKit
class FBHomeCell: UITableViewCell {

    class var cellReuseId: String {
        return String(describing: self)
    }
    
    lazy var bgView: UIView = {
        var bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 5.0
        bgView.layer.masksToBounds = true//切圆角之外的所有图层
        bgView.layer.shadowColor = UIColor.gray.cgColor
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowRadius = 5.0
        bgView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        return bgView
    }()
    
    lazy var titleLab: UILabel = {
        var titleLab = UILabel()
//        titleLab.textAlignment = .center
        return titleLab
    }()
    
    lazy var detailLab: UILabel = {
        var detailLab = UILabel()
        
        return detailLab
    }()
    
    lazy var dateLab: UILabel = {
        var dateLab = UILabel()
        dateLab.textAlignment = .right

        return dateLab
    }()
    
    lazy var iconImageView: UIImageView = {
        var iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        
        return iconImageView
    }()
    
    var itemFrame: FBHomeItemFrame? {
        didSet {
            if let itemFrame = itemFrame {
                titleLab.text = itemFrame.homeItem.title
                titleLab.font = itemFrame.titleFont
                detailLab.text = itemFrame.homeItem.detail
                detailLab.font = itemFrame.detailFont
                
                iconImageView.image = itemFrame.image ?? nil
                
                dateLab.text = itemFrame.dateStr
                dateLab.font = itemFrame.dateFont
                
                let detailLab_top = itemFrame.homeItem.detail.count > 0 ? kHomeCell_margin : 0.0
                detailLab.snp.updateConstraints { make in
                    make.top.equalTo(titleLab.snp.bottom).offset(detailLab_top)
                }
                
                let iconIV_top = itemFrame.image != nil ? kHomeCell_margin : 0.0
//                let iconIV_height = itemFrame.image != nil ? kHomeCellImage_h : 0.0
                iconImageView.snp.updateConstraints { make in
                    make.top.equalTo(detailLab.snp.bottom).offset(iconIV_top)
                    make.height.equalTo(itemFrame.image_height)
                }
                
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(titleLab)
        bgView.addSubview(detailLab)
        bgView.addSubview(iconImageView)
        bgView.addSubview(dateLab)
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    
//    func configCell(with item: FBHomeItem, isChecked: Bool = false) {
//        if isChecked {
//            let attributedStr = NSAttributedString(string: item.title, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
//
//            titleLab.attributedText = attributedStr
////            locationLab.text = nil
//            dateLab.text = nil
//        } else {
//            titleLab.text = item.title
//
//            let date = Date(timeIntervalSince1970: item.timestamp)
//            dateLab.text = dateFormatter.string(from: date)
//
//
//        }
//    }
}

extension FBHomeCell {
    private func initConstraints() {
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kHomeCell_margin)
            make.leading.equalToSuperview().offset(kHomeCell_margin)
            make.bottom.equalToSuperview().offset(-kHomeCell_margin)
            make.trailing.equalToSuperview().offset(-kHomeCell_margin)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalTo(self.bgView).offset(kHomeCell_margin)
            make.leading.equalTo(self.bgView).offset(kHomeCell_margin)
            make.trailing.equalTo(self.bgView).offset(-kHomeCell_margin)
        }
        detailLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(kHomeCell_margin)
            make.leading.equalTo(self.bgView).offset(kHomeCell_margin)
            make.trailing.equalTo(self.bgView).offset(-kHomeCell_margin)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(detailLab.snp.bottom).offset(kHomeCell_margin)
            make.centerX.equalTo(self.bgView)
            make.leading.equalTo(self.bgView).offset(kHomeCell_margin)
            make.trailing.equalTo(self.bgView).offset(-kHomeCell_margin)
            make.height.equalTo(kHomeCellImage_h)
        }
        dateLab.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(kHomeCell_margin)
            make.leading.equalTo(self.bgView).offset(kHomeCell_margin)
            make.trailing.equalTo(self.bgView).offset(-kHomeCell_margin)
        }
    }
}
