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
import FirebaseAuth
class PersonalViewController: UIViewController {
    // pickerview
    let picker0 = UIPickerView()
    let picker1 = UIPickerView()
    let period = ["月", "週", "日"]
    let category = ["食物", "飲品", "娛樂", "交通", "消費", "家用", "醫藥", "其他"]
    // firebase
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var ref: DocumentReference?
    // date
    let date = Date()
    var today: String!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()

    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBAction func sendButton(_ sender: UIButton) {
        if timeTextField.text?.isEmpty != true {
            getToday()
            addBudget(today: today)
            timeTextField.text = ""
            budgetTextField.text = ""
            categoryTextField.text = ""
            let completionController = UIAlertController(title: "完成!", message: "完成輸入預算", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            completionController.addAction(okAction)
            present(completionController, animated: true, completion: nil)
        } else {
            let remindController = UIAlertController(title: "輸入預算!", message: "請輸入您的預算金額", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            remindController.addAction(okAction)
            present(remindController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
    }

    func setupPickerView() {
        picker0.delegate = self
        picker0.tag = 0
        picker1.delegate = self
        picker1.tag = 1

        timeTextField.inputView = picker0
        categoryTextField.inputView = picker1
    }
    func addBudget(today: String) {
        let dateString = self.dateFormatter.string(from: Date())
        let doc = db.collection("User").document("\(userID ?? "user1")").collection("category")
        let id = doc.document().documentID
        doc.document(id).setData([
            "amount": Int(budgetTextField.text ?? "0") ?? 0   ,
            "category": "\(categoryTextField.text ?? "bad category")",
            "period": "\(timeTextField.text ?? "bad time")",
            "timeStamp": today,
            "date": dateString,
            "documentID": id
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
            }
        }
    }
    func getToday() {
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
            return period.count
        } else if pickerView.tag == 1 {
            return category.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return period[row]
        } else if pickerView.tag == 1 {
            return category[row]
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            timeTextField.text = period[row]
        } else if pickerView.tag == 1 {
            categoryTextField.text = category[row]
        }
    }

}
