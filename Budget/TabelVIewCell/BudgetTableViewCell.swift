//
//  BudgetTableViewCell.swift
//  Budget
//
//  Created by nono chan  on 2020/11/30.
//

import UIKit
import UICircularProgressRing
class BudgetTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var porgressView: UICircularProgressRing! {
        didSet {
            porgressView.outerRingColor = .systemGray
            porgressView.outerRingWidth = 10
            porgressView.innerRingColor = .systemIndigo
            porgressView.innerRingWidth = 10
        }
    }
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var remianingTimeLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var remainingAmountLabel: UILabel!
    @IBOutlet weak var remainingCategoryLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
