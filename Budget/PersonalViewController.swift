//
//  MoreViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/12/1.
//

import UIKit

class PersonalViewController: UIViewController {

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    let picker0 = UIPickerView()
    let picker1 = UIPickerView()

    let time = ["月", "週", "日"]
    let category = ["食物", "飲品", "娛樂", "交通", "消費", "家用", "醫藥", "收入", "其他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        picker0.delegate = self
        picker0.tag = 0

        picker1.delegate = self
        picker1.tag = 1
        timeTextField.inputView = picker0
        categoryTextField.inputView = picker1
    }
}
extension PersonalViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if picker0.tag == 1 {
            return time.count
        }
        return category.count

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if picker0.tag == 1 {
        return time[row]
        }
        return category[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeTextField.text = time[row]
        categoryTextField.text = category[row]
    }
}
