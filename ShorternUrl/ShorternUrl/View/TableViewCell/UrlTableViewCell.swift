//
//  UrlTableViewCell.swift
//  ShorternUrl
//
//  Created by ngovantucuong on 1/14/20.
//  Copyright © 2020 CuongNVT. All rights reserved.
//

import UIKit

class UrlTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var shorternUrlLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(urlStr: String, date: String) {
        shorternUrlLb.text = urlStr
        dateLb.text = date
    }
    
}
