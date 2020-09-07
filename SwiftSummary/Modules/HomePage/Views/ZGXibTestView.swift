//
//  ZGXibTestView.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/4/17.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGXibTestView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
