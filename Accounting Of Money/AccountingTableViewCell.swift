//
//  AccountingTableViewCell.swift
//  Accounting Of Money
//
//  Created by Alexandr Kurdyukov on 29.03.2018.
//  Copyright © 2018 Alexandr Kurdyukov. All rights reserved.
//

import UIKit

class AccountingTableViewCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
