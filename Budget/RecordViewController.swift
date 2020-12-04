//
//  RecordViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/27.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!

    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var entertainButton: UIButton!
    @IBOutlet weak var trafficButton: UIButton!
    @IBOutlet weak var consumeButton: UIButton!
    @IBOutlet weak var houseHoldButton: UIButton!
    @IBOutlet weak var medicalButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!

    @IBAction func confimButton(_ sender: Any) {
        amountTextField.text = "0"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

    }

}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }}

}
