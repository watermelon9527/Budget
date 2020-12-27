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
import FirebaseAuth
extension RecordViewController: QRScannerDelegate {
    func QRScanner(category: String, price: String) {
        amountTextField.text = price
        commentTextField.text = category
    }

}
class RecordViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanSegue" {
            let scanController = segue.destination as! QRScannerController
            scanController.delegate = self
        }
    }
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    let date = Date()
    var today: String!
    var ref: DocumentReference?
    var selectedCategory = ""
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
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
    @IBOutlet weak var foodButton: UIButton! {
        didSet {
            foodButton.layer.borderColor = UIColor.black.cgColor
            foodButton.layer.borderWidth = 3
            foodButton.imageView?.contentMode = .scaleAspectFill
            foodButton.setTitleColor(.black, for: .normal)
            guard let title = foodButton.currentTitle else { return }
            selectedCategory = title
        }
    }
    @IBOutlet weak var drinkButton: UIButton! {
        didSet {
            drinkButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var entertainButton: UIButton! {
        didSet {
            entertainButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var trafficButton: UIButton! {
        didSet {
            trafficButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var consumeButton: UIButton! {
        didSet {
            consumeButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var houseHoldButton: UIButton! {
        didSet {
            houseHoldButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var medicalButton: UIButton! {
        didSet {
            medicalButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var othersButton: UIButton! {
        didSet {
            othersButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var incomeButton: UIButton! {
        didSet {
            incomeButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBAction func confimButton(_ sender: Any) {
        if amountTextField.text?.isEmpty == true {
                        let controller = UIAlertController(title: "輸入金額!", message: "請輸入您的支出金額", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        controller.addAction(okAction)
                        present(controller, animated: true, completion: nil)
        } else if amountTextField.text == "0" {
            let controller1 = UIAlertController(title: "金額不可為0!", message: "請輸入您的支出金額", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller1.addAction(okAction)
            present(controller1, animated: true, completion: nil)
        } else {
            getDate()
            addData(today: today)
            let controller2 = UIAlertController(title: "完成記帳", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller2.addAction(okAction)
            present(controller2, animated: true, completion: nil)
            amountTextField.text = ""
            commentTextField.text = ""
        }
    }
    @IBOutlet var categoryButtons: [UIButton]!
    @IBAction func categoryButtons(_ sender: UIButton) {
        let tag = sender.tag
        for button in categoryButtons {
            if button.tag == tag {
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.borderWidth = 2
                button.setTitleColor(.black, for: .normal)
            } else {
                button.layer.borderColor = UIColor.gray.cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(.gray, for: .normal)
                button.backgroundColor = .white
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        recordWillAppear()
    }
    func recordWillAppear() {
        self.tabBarController?.tabBar.isHidden = false
        amountTextField.text = ""
        commentTextField.text = ""

        foodButton.layer.borderColor = UIColor.black.cgColor
        foodButton.layer.borderWidth = 2
        foodButton.setTitleColor(.black, for: .normal)

        guard let title = foodButton.currentTitle else { return }
        selectedCategory = title

        drinkButton.layer.borderWidth = 1
        drinkButton.layer.borderColor = UIColor.gray.cgColor
        drinkButton.setTitleColor(.gray, for: .normal)

        entertainButton.layer.borderWidth = 1
        entertainButton.layer.borderColor = UIColor.gray.cgColor
        entertainButton.setTitleColor(.gray, for: .normal)

        trafficButton.layer.borderWidth = 1
        trafficButton.layer.borderColor = UIColor.gray.cgColor
        trafficButton.setTitleColor(.gray, for: .normal)

        consumeButton.layer.borderWidth = 1
        consumeButton.layer.borderColor = UIColor.gray.cgColor
        consumeButton.setTitleColor(.gray, for: .normal)

        houseHoldButton.layer.borderWidth = 1
        houseHoldButton.layer.borderColor = UIColor.gray.cgColor
        houseHoldButton.setTitleColor(.gray, for: .normal)

        medicalButton.layer.borderWidth = 1
        medicalButton.layer.borderColor = UIColor.gray.cgColor
        medicalButton.setTitleColor(.gray, for: .normal)

        othersButton.layer.borderWidth = 1
        othersButton.layer.borderColor = UIColor.gray.cgColor
        othersButton.setTitleColor(.gray, for: .normal)

        incomeButton.layer.borderWidth = 1
        incomeButton.layer.borderColor = UIColor.gray.cgColor
        incomeButton.setTitleColor(.gray, for: .normal)
    }
    func listen() {
        db.collection("User").document("\(userID ?? "user1")").collection("record")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                _ = document.documentChanges.map {print($0.document.data())}
            }
    }
    func addData(today: String) {
        let dateString = self.dateFormatter.string(from: Date())

        let doc = db.collection("User").document("\(userID ?? "user1")").collection("record")

        let id = doc.document().documentID

        doc.document(id).setData([
            "amount": Int(amountTextField.text ?? "0") ?? 0   ,
            "category": selectedCategory,
            "comments": "\(commentTextField.text ?? "bad")",
            "timeStamp": today,
            "date": dateString,
            "documentID": id
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
            }
        }
//        ref = db
//            .collection("User")
//            .document("\(userID ?? "user1")")
//            .collection("record")
//            .document(id)
//            .setData([
//                "amount": Int(amountTextField.text ?? "0") ?? 0   ,
//                "category": selectedCategory,
//                "comments": "\(commentTextField.text ?? "bad")",
//                "timeStamp": today,
//                "date": dateString,
//                "doucumentID": ""
//            ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                self.update()
//                print("Document added with ID: \(self.ref?.documentID ?? "9999")")
//            }
//        }
    }
//    func update() {
//        db.collection("User").document("\(userID ?? "user1")").collection("record").getDocuments { (querySnapshot, error) in
//            if let querySnapshot = querySnapshot {
//                let document = querySnapshot.documents.first
//                document?.reference.updateData(["doucumentID": self.ref?.documentID ?? 0 ], completion: { (error) in
//                })
//            }
//        }
//    }

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
