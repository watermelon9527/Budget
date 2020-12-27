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
import FirebaseAuth

class BudgetViewController: UIViewController, UITableViewDelegate {
    let userID = Auth.auth().currentUser?.uid

    var cell = BudgetTableViewCell()
    var db = Firestore.firestore()

    var progressPercentage: Int = 0
    var today: String!
    let date = Date()
    var amountArray = [Int]()
    var sum: Int = 0
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
    }
    override func viewWillAppear(_ animated: Bool) {
        self.budgetArray = []
        loadData()
        budgetTableView.reloadData()

    }
    override func viewDidAppear(_ animated: Bool) {}
    var budgetArray = [Budget]()

    func loadData() { loadBudgetCategory { [weak self] (newRecords) in
            self?.getDate()
            self?.budgetArray = newRecords
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

    func loadBudgetCategory(completion: @escaping ([Budget]) -> Void) {
        db.collection("User").document("\(userID ?? "user1")").collection("category").getDocuments { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                var budgetArray = [Budget]()
                for document in snapshot!.documents {
                    let data = document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let category = data["category"] as? String ?? ""
                    let timeStamp = data["timeStamp"] as? String ?? ""
                    let period = data["period"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let documentID = data["documentID"] as? String ?? ""

                    let newRecord =
                        Budget(amount: amount, category: category, timeStamp: timeStamp, date: date, period: period, documentID: documentID)
                    budgetArray.append(newRecord)
//                    print(budgetArray)
                }
                completion(budgetArray)
                self.budgetTableView.reloadData()
            }
        }
    }
    func loadRecordAmount(day1: String, day2: String, category: String, completion: @escaping(Int) -> Void) {
        db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isLessThanOrEqualTo: day2)
            .whereField("date", isGreaterThanOrEqualTo: day1 )
            .whereField("category", isEqualTo: category)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        let amount = data["amount"] as? Int ?? 0
                        self.amountArray.append(amount)
                        let sum = self.amountArray.reduce(0, +)
//                        print(sum)
                        self.sum = sum
                    }
                    completion(self.sum)
                }
            }
    }
    func date2String(_ date: Date, dateFormat: String = "MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
     func dateStringToDate(_ dateStr: String) -> Date {

        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "YYYY/MM/dd"
          let date = dateFormatter.date(from: dateStr)
          return date ?? Date()
        }
    var weekArray = [String]()
    func sevenDay(firstday: String) {
        let date1 = dateStringToDate(firstday)
        let day1 = date2String(date1, dateFormat: "MM/dd")
        weekArray.append(day1)

        let date2 = date1.dayAfter
        let day2 = date2String(date2, dateFormat: "MM/dd")
        weekArray.append(day2)

        let date3 = date2.dayAfter
        let day3 = date2String(date3, dateFormat: "MM/dd")

        weekArray.append(day3)

        let date4 = date3.dayAfter
        let day4 = date2String(date4, dateFormat: "MM/dd")
        weekArray.append(day4)

        let date5 = date4.dayAfter
        let day5 = date2String(date5, dateFormat: "MM/dd")
        weekArray.append(day5)

        let date6 = date5.dayAfter
        let day6 = date2String(date6, dateFormat: "MM/dd")
        weekArray.append(day6)

        let date7 = date6.dayAfter
        let day7 = date2String(date7, dateFormat: "MM/dd")
        weekArray.append(day7)
    }
    var monthArray = [String]()

    func fetchDays(count: Int, firstday: String) {

        var date = dateStringToDate(firstday)
        for _ in 1...count {

            let dayString = date2String(date, dateFormat: "MM/dd")
            monthArray.append(dayString)
            date = date.dayAfter
        }
        print(monthArray)
    }

    func thirtyDay(firstday: String) {
        var date = dateStringToDate(firstday)
        for _ in 1...30 {
            let dayString = date2String(date, dateFormat: "MM/dd")
            monthArray.append(dayString)
            date = date.dayAfter
        }
        print(monthArray)
    }
}
extension BudgetViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let documentID = budgetArray[indexPath.row].documentID
            let userID = Auth.auth().currentUser?.uid

            let collectionReference = db.collection("User").document("\(userID ?? "user1")").collection("category")
            let query: Query = collectionReference.whereField("documentID", isEqualTo: documentID)
            query.getDocuments(completion: { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    for document in snapshot!.documents {

                                        self.db.collection("User").document("\(userID ?? "user1")").collection("category")
                                            .document("\(document.documentID)").delete()
                                    }
                                }})
            budgetArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = budgetTableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath) as! BudgetTableViewCell
        let budget = budgetArray[indexPath.row]
        getDate()
        amountArray = []
        loadRecordAmount(day1: budget.date, day2: today, category: budget.category) { [ weak self ] (sum) in
            cell.remainderAmountLabel.text = "$\(budget.amount-sum)"
//            let remain = budget.amount-sum
//            if remain <= 0 {
//                cell.remainderAmountLabel.textColor = .red
//            } else {
//                cell.remainderAmountLabel.textColor = .black
//            }

            let remainAmount = Double(budget.amount-sum)
            let amount = Double(budget.amount)
            let progressPercentage = remainAmount/amount*100
            cell.circleView.startProgress(to: CGFloat(progressPercentage), duration: 1.5)
            self?.amountArray.removeAll()
        }
        cell.remainderCategoryLabel.text = "剩餘金額"
        cell.categoryLabel.text = "本\(budget.period)\(budget.category)預算"
        cell.amountLabel.text = "$\(budget.amount)"

        sevenDay(firstday: budget.date)
        thirtyDay(firstday: budget.date)

        let monthLastDay = String(monthArray.last ?? "111")
        let weekLastDay = String(weekArray.last ?? "111")
        if budget.period == "月" {
            cell.remianingTimeLabel.text = "\(budget.date)～\(monthLastDay)"
        } else if budget.period == "週" {
            cell.remianingTimeLabel.text = "\(budget.date)～\(weekLastDay) "
        } else if budget.period == "日" {
            cell.remianingTimeLabel.text = "\(budget.date)"
        }

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
        return 206
    }
}
