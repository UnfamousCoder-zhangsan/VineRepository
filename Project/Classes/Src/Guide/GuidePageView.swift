//
//  GuideView1.swift
//  LawChatForLawyer
//
//  Created by JW on 2018/2/8.
//  Copyright © 2018年 就问律师. All rights reserved.
//

import UIKit
@objcMembers
class GuidePageView: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!

    var page: NSInteger = 0 {
        didSet {
            switch page {
            case 0:
                imageView.image = UIImage(named: "guide_pages_1")
                titleLabel.text = "海量用户，及时触达"
            case 1:
                imageView.image = UIImage(named: "guide_pages_2")
                titleLabel.text = "高效便捷，移动办公"
            case 2:
                imageView.image = UIImage(named: "guide_pages_3")
                titleLabel.text = "成为信得过的好律师"
            default:
                break
            }
        }
    }
}
