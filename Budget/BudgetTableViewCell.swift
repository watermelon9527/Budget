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
    
    @IBOutlet weak var circleView: UICircularProgressRing! {
        didSet {
            circleView.outerRingColor = .systemGray
            circleView.outerRingWidth = 10
            circleView.innerRingColor = .systemIndigo
            circleView.innerRingWidth = 10
        }
    }
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var remainderAmount: UILabel!
    @IBOutlet weak var remainderCategory: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        circleView.startProgress(to: 60, duration: 2)

    }

}
