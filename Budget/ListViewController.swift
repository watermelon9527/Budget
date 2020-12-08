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
    func loaddata() {                                           db.collection("user").document().collection("record").getDocuments{
        snapshot, error in
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            for document in snapshot!.documents {

                let data = document.data()
                let amount = data["amount"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let timeStamp = data["timeStamp"] as? Date ?? Date()
                let commit = data["commit"] as? String ?? ""
                let newRecord = Record(amount:amount, category:category, timeStamp: timeStamp,commit:commit)
                self.recordArray.append(newRecord)

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
        cell.amountLabel.text = "\(record.amount)"
        cell.categoryLabel.text = "\(record.category)"
        cell.commitLabel.text = "\(record.commit)"
        cell.timeLabel.text = "\(record.timeStamp)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
