//
//  ListTableViewCell.swift
//  myAprication004
//
//  Created by Apple on 2016/11/29.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    /// イメージを表示するImageView
    @IBOutlet weak var myImageView: UIImageView!
    /// タイトルを表示するLabel
    @IBOutlet weak var myTitleLabel: UILabel!
    ///日付を表示する
    @IBOutlet weak var myDateLabel: UILabel!
    ///カテゴリーを表示する
    @IBOutlet weak var myCategoryLabel: UIView!
    /// 説明を表示するLabel
    @IBOutlet weak var myDescriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// 画像・タイトル・説明文を設定するメソッド
    func setCell(imageName: String, titleText: String, descriptionText: String) {
        myImageView.image = UIImage(named: imageName)
        myTitleLabel.text = titleText
        myDescriptionLabel.text = descriptionText
    }
}
