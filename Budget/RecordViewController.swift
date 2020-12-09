//
//  RecordViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/27.
//

import UIKit
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
class RecordViewController: UIViewController {
    let db = Firestore.firestore()
    var ref: DocumentReference?
    let date = Date()
    var today: String!
    var selectedCategory = ""

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var foodButton: UIButton!
    @IBAction func foodBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func drinkBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func entertainBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func trafficBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func consumeBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func houseHoldBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func medicalBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func incomeBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBAction func othersBTN(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        selectedCategory = title
    }
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var entertainButton: UIButton!
    @IBOutlet weak var trafficButton: UIButton!
    @IBOutlet weak var consumeButton: UIButton!
    @IBOutlet weak var houseHoldButton: UIButton!
    @IBOutlet weak var medicalButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBAction func confimButton(_ sender: Any) {
        getDate()
        addData(today: today)
        amountTextField.text = "0"
    }
    @IBOutlet var categoryButtons: [UIButton]!
    @IBAction func categoryButtons(_ sender: UIButton) {
        let tag = sender.tag
        for button in categoryButtons {
            if button.tag == tag {
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(red: 89/255, green: 142/255, blue: 212/255, alpha: 1)
            } else {
                button.setTitleColor(.gray, for: .normal)
                button.backgroundColor = .white
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    func addData(today: String) {
        let dateString = self.dateFormatter.string(from: Date())
        ref = db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("record").addDocument(data: [
            "amount": Int(amountTextField.text ?? "0") ?? 0   ,
            "category": selectedCategory,
            "comments": "\(commentTextField.text ?? "bad")",
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
