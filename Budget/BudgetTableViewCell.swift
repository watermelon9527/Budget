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
        // Initialization code
    }
    
    @IBOutlet weak var circleView: UICircularProgressRing! {
        didSet {
            circleView.outerRingColor = .systemGray
            circleView.outerRingWidth = 5
            circleView.innerRingColor = .systemIndigo

        }
    }
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
