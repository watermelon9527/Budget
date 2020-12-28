//
//  ListTableViewCell.swift
//  Budget
//
//  Created by nono chan  on 2020/11/30.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBOutlet weak var commitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
