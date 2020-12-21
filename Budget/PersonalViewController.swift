//
//  MoreViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/12/1.
//

import UIKit
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
class PersonalViewController: UIViewController {
    let picker0 = UIPickerView()
    let picker1 = UIPickerView()
    let time = ["月", "週", "日"]
    let category = ["食物", "飲品", "娛樂", "交通", "消費", "家用", "醫藥", "收入", "其他"]
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBAction func sendButton(_ sender: UIButton) {
        if timeTextField.text?.isEmpty != true {
            getDate()
            addBudget(today: today)
            timeTextField.text = ""
            budgetTextField.text = ""
            categoryTextField.text = ""
            let controller2 = UIAlertController(title: "完成!", message: "完成輸入預算", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller2.addAction(okAction)
            present(controller2, animated: true, completion: nil)
        } else {
            let controller = UIAlertController(title: "輸入預算!", message: "請輸入您的預算金額", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }

    let db = Firestore.firestore()
    var ref: DocumentReference?
    let date = Date()
    var today: String!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker0.delegate = self
        picker0.tag = 0
        picker1.delegate = self
        picker1.tag = 1

        timeTextField.inputView = picker0
        categoryTextField.inputView = picker1
    }
    func addBudget(today: String) {
        let dateString = self.dateFormatter.string(from: Date())
        ref = db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("category").addDocument(data: [
            "amount": Int(budgetTextField.text ?? "0") ?? 0   ,
            "category": "\(categoryTextField.text ?? "bad category")",
            "period": "\(timeTextField.text ?? "bad time")",
            "timeStamp": today,
            "date": dateString
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref?.documentID ?? "9999")")
            }
        }
    }
    func getDate() {
        let timeStamp = date.timeIntervalSince1970
        let timeInterval = TimeInterval(timeStamp)

        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        today = dateFormatter.string(from: date)
    }

}
extension PersonalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return time.count
        } else if pickerView.tag == 1 {
            return category.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return time[row]
        } else if pickerView.tag == 1 {
            return category[row]
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            timeTextField.text = time[row]
        } else if pickerView.tag == 1 {
            categoryTextField.text = category[row]
        }
    }

}
