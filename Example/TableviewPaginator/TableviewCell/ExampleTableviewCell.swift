//
//  ExampleTableviewCell.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SDWebImage

class ExampleTableviewCell: UITableViewCell {

    @IBOutlet weak var mViewUserProfileImage: UIImageView!
    @IBOutlet weak var mViewUserFullName: UILabel!

    func customize(user: User?) {

        mViewUserProfileImage.image = nil
        mViewUserFullName.text = ""

        guard let user = user else {
            return
        }

        mViewUserFullName.text = user.firstName + " " + user.lastName
        if let url = URL.init(string: user.avatar) {
            mViewUserProfileImage.sd_setImage(with: url, completed: nil)
        }
    }

}
