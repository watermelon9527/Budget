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


    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource = self
        listTableView.delegate = self

        db = Firestore.firestore()
        loaddata()

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
                    let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments)
                    self.recordArray.append(newRecord)
                }
                self.listTableView.reloadData()
            }
        }
    }
    //將時間戳轉換為年月日
     func timeStampToString(_ timeStamp:Date)->String {
//        let string = NSString(string: timeStamp)
      //  let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.timeZone = NSTimeZone.local
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
        let date = record.timeStamp
        let time = timeStampToString(date)
        cell.commitLabel.text = "\(record.comments)"
    //  cell.timeLabel.text = "\(record.timeStamp)"
          cell.timeLabel.text = time
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
}
