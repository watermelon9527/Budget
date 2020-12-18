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
class ListViewController: UIViewController {

    @IBOutlet weak var FSCalendar: FSCalendar!
    @IBOutlet weak var listTableView: UITableView!

    var db: Firestore!
    var allRecordArray = [Record]()
    var recordArray = [Record]()
    var datesWithEvent = [Record]()
    var selectedDate = Date()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    override func viewDidDisappear(_ animated: Bool) {
        datesWithEvent = []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.backgroundColor = .systemGray5
        listTableView.dataSource = self
        listTableView.delegate = self
        FSCalendar.delegate = self
        FSCalendar.dataSource = self
        db = Firestore.firestore()

//        let dateString = self.dateFormatter.string(from: Date())
//        listen(time: dateString)

        listTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FSCalendar.backgroundColor = .systemGray6
        let dateString = self.dateFormatter.string(from: selectedDate)
        listen(time: dateString)
        self.recordArray = []
        listTableView.reloadData()
        self.FSCalendar.reloadData()
    }

    fileprivate func fetchDate(_ dateString: String) {
        for record in allRecordArray
        where record.date == dateString {
            recordArray.append(record)
        }
    }
    func listen(time: String) {
        let dateString = self.dateFormatter.string(from: selectedDate)
        db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("record").order(by: "timeStamp", descending: true)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.allRecordArray.removeAll()
                _ = document.documentChanges.map {
                    //       print($0.document.data())
                    let data = $0.document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let category = data["category"] as? String ?? ""
                    let timeStamp = data["timeStamp"] as? String ?? ""
                    let comments = data["comments"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date)
                    self.allRecordArray.append(newRecord)
                }
                self.fetchDate(dateString)
                self.listTableView.reloadData()
                self.FSCalendar.reloadData()
            }
    }
    func loadRecord(time: String) {db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("record").whereField("date", isEqualTo: time).getDocuments { snapshot, error in
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            for document in snapshot!.documents {
                //     print(document.data())
                let data = document.data()
                let amount = data["amount"] as? Int ?? 0
                let category = data["category"] as? String ?? ""
                let timeStamp = data["timeStamp"] as? String ?? ""
                let comments = data["comments"] as? String ?? ""
                let date = data["date"] as? String ?? ""
                let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date)
                self.recordArray.append(newRecord)
                self.datesWithEvent.append(newRecord)
            }
            self.listTableView.reloadData()
        }
    }
    }

}
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let record = recordArray[indexPath.row]

        cell.amountLabel.text = "$\(record.amount)"
        cell.categoryLabel.text = "\(record.category)"
        cell.commitLabel.text = "\(record.comments)"
        cell.timeLabel.text = "\(record.timeStamp)"
        if record.category == "食物" {
            cell.categoryImageView.image = UIImage(named: "ic_Food" )
        } else if record.category == "飲品" {
            cell.categoryImageView.image = UIImage(named: "ic_drink" )
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
        print(selectedDate)
        let dateString = self.dateFormatter.string(from: date)
        self.recordArray = []
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
            return UIImage(systemName: "circle.fill")!.resized(to: CGSize(width: 6, height: 6))
        }
        return nil
    }

}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
