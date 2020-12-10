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
    var recordArray = [Record]()
    private var document: [DocumentSnapshot] = []
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource = self
        listTableView.delegate = self
        FSCalendar.delegate = self
        FSCalendar.dataSource = self
        db = Firestore.firestore()
        //顯示目前日期
        let dateString = self.dateFormatter.string(from: Date())
        loaddata1(time: dateString)
        //loaddata()
        listTableView.reloadData()
    }
    func loaddata() {
        db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("record").getDocuments { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for document in snapshot!.documents {
                    print(document.data())
                    let data = document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let category = data["category"] as? String ?? ""
                    let timeStamp = data["timeStamp"] as? Date ?? Date()
                    let comments = data["comments"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date)
                    self.recordArray.append(newRecord)
                }
                self.listTableView.reloadData()
            }
        }
    }
    func loaddata1(time: String) {db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("record").whereField("date", isEqualTo: time).getDocuments { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for document in snapshot!.documents {
                    print(document.data())
                    let data = document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let category = data["category"] as? String ?? ""
                    let timeStamp = data["timeStamp"] as? Date ?? Date()
                    let comments = data["comments"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date)
                    self.recordArray.append(newRecord)
                }
                self.listTableView.reloadData()
            }
        }
    }
    //將時間戳轉換為年月日
    func timeStampToString(_ timeStamp: Date) -> String {
        //        let string = NSString(string: timeStamp)
        //  let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        //        dfmatter.timeZone = NSTimeZone.local
        dfmatter.dateFormat="yyyy年MM月dd日"
        //    let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: timeStamp)
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
        //        let date = record.timeStamp
        //        let time = timeStampToString(date)
        //        cell.timeLabel.text = "time"
        cell.timeLabel.text = "\(record.date)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
}
extension ListViewController: FSCalendarDelegate, FSCalendarDataSource, UIGestureRecognizerDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.dateFormatter.string(from: date)
        //   print("did select date \(dateString)")
        self.recordArray = []
        loaddata1(time: dateString)
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
}
