//
//  ListViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/27.
//

import UIKit
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
import FSCalendar
import FirebaseAuth
class ListViewController: UIViewController {
    // firebase
    let userID = Auth.auth().currentUser?.uid
    var db: Firestore!
    // data array
    var allRecordArray = [Record]()
    var theDateRecordArray = [Record]()
    var datesWithEvent = [Record]()
    // date
    var selectedDate = Date()
    var weekRange = Date()
    let calendarImage = UIImage(systemName: "circle.fill")
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    @IBOutlet weak var fSCalendar: FSCalendar!
    @IBOutlet weak var listTableView: UITableView!
    override func viewDidDisappear(_ animated: Bool) {
        datesWithEvent = []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupListTableViewAtviewDidLoad()
        setupfSCalendarAtViewDidload()
        db = Firestore.firestore()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fSCalendar.backgroundColor = .systemGray6
        let dateString = self.dateFormatter.string(from: selectedDate)
        listenRecord(time: dateString)
        self.theDateRecordArray = []
        listTableView.reloadData()
        self.fSCalendar.reloadData()
    }
    func setupfSCalendarAtViewDidload() {
        fSCalendar.firstWeekday = 2
        fSCalendar.clipsToBounds = true
        fSCalendar.delegate = self
        fSCalendar.dataSource = self
    }
    func setupListTableViewAtviewDidLoad() {
        listTableView.backgroundColor = .systemGray5
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.reloadData()
    }

    func listenRecord(time: String) {
        let dateString = self.dateFormatter.string(from: selectedDate)
        db.collection("User").document("\(userID ?? "user1")").collection("record").order(by: "timeStamp", descending: true)
            .order(by: "date", descending: true)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.allRecordArray.removeAll()
                _ = document.documentChanges.map {
                    let data = $0.document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let category = data["category"] as? String ?? ""
                    let timeStamp = data["timeStamp"] as? String ?? ""
                    let comments = data["comments"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let documentID = data["documentID"] as? String ?? ""
                    let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date,
                                           documentID: documentID)
                    self.allRecordArray.append(newRecord)
                }
                self.fetchTheDate(dateString)
                self.listTableView.reloadData()
                self.fSCalendar.reloadData()
            }
    }
    func loadRecord(time: String) {db.collection("User").document("\(userID ?? "user1")").collection("record").whereField("date", isEqualTo: time).getDocuments { snapshot, error in
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            for document in snapshot!.documents {
                let data = document.data()
                let amount = data["amount"] as? Int ?? 0
                let category = data["category"] as? String ?? ""
                let timeStamp = data["timeStamp"] as? String ?? ""
                let comments = data["comments"] as? String ?? ""
                let date = data["date"] as? String ?? ""
                let documentID = data["documentID"] as? String ?? ""
                let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date,
                                       documentID: documentID)
                self.theDateRecordArray.append(newRecord)
                self.datesWithEvent.append(newRecord)
            }
            self.listTableView.reloadData()
        }
    }
    }
    fileprivate func fetchTheDate(_ dateString: String) {
        for record in allRecordArray
        where record.date == dateString {
            theDateRecordArray.append(record)
        }
    }
}
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theDateRecordArray.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let documentID = theDateRecordArray[indexPath.row].documentID
            let userID = Auth.auth().currentUser?.uid
            let collectionReference = db.collection("User").document("\(userID ?? "user1")").collection("record")
            let query: Query = collectionReference.whereField("documentID", isEqualTo: documentID)
            query.getDocuments(completion: { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    for document in snapshot!.documents {

                                        self.db.collection("User").document("\(userID ?? "user1")").collection("record")
                                            .document("\(document.documentID)").delete()
                                    }
                                    self.fSCalendar.reloadData()

                                }})
            theDateRecordArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let record = theDateRecordArray[indexPath.row]
        cell.amountLabel.text = "$\(record.amount)"
        cell.categoryLabel.text = "\(record.category)"
        cell.commentLabel.text = "\(record.comments)"
        cell.timeLabel.text = "\(record.timeStamp)"
        if record.category == "食物" {
            cell.categoryImageView.image = UIImage(named: "ic_Food" )
        } else if record.category == "飲品" {
            cell.categoryImageView.image = UIImage(named: "ic_beer" )
        } else if record.category == "娛樂" {
            cell.categoryImageView.image = UIImage(named: "ic_entertainmmment" )
        } else if record.category == "交通" {
            cell.categoryImageView.image = UIImage(named: "ic_car" )
        } else if record.category == "消費" {
            cell.categoryImageView.image = UIImage(named: "ic_Clothes" )
        } else if record.category == "家用" {
            cell.categoryImageView.image = UIImage(named: "ic_home" )
        } else if record.category == "醫藥" {
            cell.categoryImageView.image = UIImage(named: "ic_medical" )
        } else if record.category == "收入" {
            cell.categoryImageView.image = UIImage(named: "ic_sell" )
        } else if record.category == "其他" {
            cell.categoryImageView.image = UIImage(named: "ic_other" )}
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
}
extension ListViewController: FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        let dateString = self.dateFormatter.string(from: date)
        self.theDateRecordArray = []
        loadRecord(time: dateString)
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let dateString = self.dateFormatter.string(from: date)
        if allRecordArray.map({ $0.date }).contains(dateString) {
            return calendarImage!.resized(to: CGSize(width: 6, height: 6))
        } 
        return nil
    }
}
