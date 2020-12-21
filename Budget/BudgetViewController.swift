//
//  ViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/25.
//

import UIKit
import UICircularProgressRing
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
class BudgetViewController: UIViewController, UITableViewDelegate {

    var cell = BudgetTableViewCell()
    var db = Firestore.firestore()
    var budgetArray = [Budget]()
    var proogressPercentage: Int = 0
    var today: String!
    let date = Date()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    @IBOutlet weak var budgetTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetTableView.dataSource = self
        budgetTableView.delegate = self
        budgetTableView.backgroundColor = .systemGray5
//        let dateString = self.dateFormatter.string(from: today)
//        loadBudgetCategory()
    }
    override func viewWillAppear(_ animated: Bool) {
//        budgetArray = []
        loadBudgetCategory()

    }
    override func viewDidAppear(_ animated: Bool) {
//        let circle = cell.circleView
   //     circle?.startProgress(to: 60, duration: 1)
    }
    func getDate() {
        let timeStamp = date.timeIntervalSince1970
        let timeInterval = TimeInterval(timeStamp)

        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        today = dateFormatter.string(from: date)
    }
    func loadBudgetCategory() {
        db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("category").getDocuments { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let category = data["category"] as? String ?? ""
                    let timeStamp = data["timeStamp"] as? String ?? ""
                    let period = data["period"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let newRecord = Budget(amount: amount, category: category, timeStamp: timeStamp, date: date, period: period)
                    self.budgetArray.append(newRecord)
                }
                self.budgetTableView.reloadData()
            }
        }
    }
    func loadRecordAmount(time: String, day: String) {
        db.collection("User").document("Y04LSGt0HVgAmmAO8ojU").collection("record")
            .whereField("date", isGreaterThanOrEqualTo: day)
            .whereField("date", isLessThanOrEqualTo: time)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        print(data)
                        let amount = data["amount"] as? Int ?? 0
                        let category = data["category"] as? String ?? ""
                        let timeStamp = data["timeStamp"] as? String ?? ""
                        let comments = data["comments"] as? String ?? ""
                        let date = data["date"] as? String ?? ""
                        let newRecord = Record(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date)
                        print(newRecord)
//                        let today = self.dateStringToDate(date)
//                        self.recordArray.append(newRecord)
//                        self.datesWithEvent.append(newRecord)
                    }
//                    self.listTableView.reloadData()
                }
            }
        }
}

extension BudgetViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = budgetTableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath) as! BudgetTableViewCell
        let budget = budgetArray[indexPath.row]
        getDate()
        loadRecordAmount(time: budget.date, day: today)

        cell.amountLabel.text = "$\(budget.amount)"
        cell.remainderCategory.text = "剩餘金額"
        cell.remainderAmount.text = "$\(budget.amount-1000)"

        proogressPercentage = budget.amount/1000
        cell.categoryLabel.text = "本\(budget.period)\(budget.category)預算"
        cell.circleView.startProgress(to: CGFloat(proogressPercentage), duration: 2)

        if budget.category == "食物" {
            cell.categoryImage.image = UIImage(named: "ic_Food" )
        } else if budget.category == "飲品" {
            cell.categoryImage.image = UIImage(named: "ic_beer" )
        } else if budget.category == "娛樂" {
            cell.categoryImage.image = UIImage(named: "ic_entertainmmment" )
        } else if budget.category == "交通" {
            cell.categoryImage.image = UIImage(named: "ic_car" )
        } else if budget.category == "消費" {
            cell.categoryImage.image = UIImage(named: "ic_Clothes" )
        } else if budget.category == "家用" {
            cell.categoryImage.image = UIImage(named: "ic_home" )
        } else if budget.category == "醫藥" {
            cell.categoryImage.image = UIImage(named: "ic_medical" )
        } else if budget.category == "收入" {
            cell.categoryImage.image = UIImage(named: "ic_sell" )
        } else if budget.category == "其他" {
            cell.categoryImage.image = UIImage(named: "ic_other" )}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableView.automaticDimension
        return 206
    }
}
