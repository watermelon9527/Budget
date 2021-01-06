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
    // Firebase
    var db = Firestore.firestore()
    // Data
    var amountArray = [Int]()
//    var sum: Int = 0
    var budgetArray = [Budget]()
    var weekArray = [String]()
    var monthArray = [String]()
    // Date
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
        setupBudgetTableViewAtViewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {}
    override func viewWillAppear(_ animated: Bool) {
        self.budgetArray = []
        loadData()
        budgetTableView.reloadData()
    }

    func setupBudgetTableViewAtViewDidLoad() {
        budgetTableView.dataSource = self
        budgetTableView.delegate = self
        budgetTableView.backgroundColor = .systemGray5
    }
    func loadData() { FirestoreManger.shared.loadBudgetCategory { [weak self] (newRecords) in
        self?.getToday()
        self?.budgetArray = newRecords
        self?.budgetTableView.reloadData()
    }
    }
    func dateToString(_ date: Date, dateFormat: String = "MM-dd") -> String {
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
    func sevenDay(firstday: String) {
        let date1 = dateStringToDate(firstday)
        let day1 = dateToString(date1, dateFormat: "yyyy/MM/dd")
        weekArray.append(day1)

        let date2 = date1.dayAfter
        let day2 = dateToString(date2, dateFormat: "yyyy/MM/dd")
        weekArray.append(day2)

        let date3 = date2.dayAfter
        let day3 = dateToString(date3, dateFormat: "yyyy/MM/dd")

        weekArray.append(day3)

        let date4 = date3.dayAfter
        let day4 = dateToString(date4, dateFormat: "yyyy/MM/dd")
        weekArray.append(day4)

        let date5 = date4.dayAfter
        let day5 = dateToString(date5, dateFormat: "yyyy/MM/dd")
        weekArray.append(day5)

        let date6 = date5.dayAfter
        let day6 = dateToString(date6, dateFormat: "yyyy/MM/dd")
        weekArray.append(day6)

        let date7 = date6.dayAfter
        let day7 = dateToString(date7, dateFormat: "yyyy/MM/dd")
        weekArray.append(day7)
    }
    func getToday() {
        let timeStamp = date.timeIntervalSince1970
        let timeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        today = dateFormatter.string(from: date)
    }
    func fetchDays(count: Int, firstday: String) {
        var date = dateStringToDate(firstday)
        for _ in 1...count {
            let dayString = dateToString(date, dateFormat: "MM/dd")
            monthArray.append(dayString)
            date = date.dayAfter
        }
    }
    func thirtyDay(firstday: String) {
        var date = dateStringToDate(firstday)
        for _ in 1...30 {
            let dayString = dateToString(date, dateFormat: "yyyy/MM/dd")
            monthArray.append(dayString)
            date = date.dayAfter
        }
    }
    func findLastDay(firstday: String, lastday: Int) -> String {
        var date = dateStringToDate(firstday)
        for _ in 1...lastday {
            date = date.dayAfter
        }
        let dayString = dateToString(date, dateFormat: "yyyy/MM/dd")
        return dayString

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
        cell.remainingCategoryLabel.text = "剩餘金額"
        cell.categoryLabel.text = "本\(budget.period)\(budget.category)預算"
        cell.amountLabel.text = "$\(budget.amount)"

        sevenDay(firstday: budget.date)
        thirtyDay(firstday: budget.date)

        let monthLastDay = String(monthArray.last ?? "111")
        let weekLastDay = String(weekArray.last ?? "111")

        if budget.period == "月" {
            amountArray = []
            let lastDay = findLastDay(firstday: budget.date, lastday: 30)
            FirestoreManger.shared.loadRecordAmount(day1: budget.date, day2: lastDay, category: budget.category) { [ weak self ] (sum) in
                cell.remainingAmountLabel.text = "$\(budget.amount-sum)"

                let remainAmount = Double(budget.amount-sum)
                if remainAmount <= 0 {
                    cell.remainingAmountLabel.textColor = .red
                } else {
                    cell.remainingAmountLabel.textColor = .black
                }
                let amount = Double(budget.amount)
                let progressPercentage = remainAmount/amount*100
                cell.porgressView.startProgress(to: CGFloat(progressPercentage), duration: 1.5)
                self?.amountArray.removeAll()
            }
            cell.remianingTimeLabel.text = "\(budget.date)～\(monthLastDay)"
        } else if budget.period == "週" {
            amountArray = []
            let lastDay = findLastDay(firstday: budget.date, lastday: 6)
            FirestoreManger.shared.loadRecordAmount(day1: budget.date, day2: lastDay, category: budget.category) { [ weak self ] (sum) in
                cell.remainingAmountLabel.text = "$\(budget.amount-sum)"

                let remainAmount = Double(budget.amount-sum)
                if remainAmount <= 0 {
                    cell.remainingAmountLabel.textColor = .red
                } else {
                    cell.remainingAmountLabel.textColor = .black
                }
                let amount = Double(budget.amount)
                let progressPercentage = remainAmount/amount*100
                cell.porgressView.startProgress(to: CGFloat(progressPercentage), duration: 1.5)
                self?.amountArray.removeAll()
            }
            cell.remianingTimeLabel.text = "\(budget.date)～\(weekLastDay) "
        } else if budget.period == "日" {
            amountArray = []
            FirestoreManger.shared.loadRecordAmount(day1: budget.date, day2: budget.date, category: budget.category) { [ weak self ] (sum) in
                cell.remainingAmountLabel.text = "$\(budget.amount-sum)"

                let remainAmount = Double(budget.amount-sum)
                if remainAmount <= 0 {
                    cell.remainingAmountLabel.textColor = .red
                } else {
                    cell.remainingAmountLabel.textColor = .black
                }
                let amount = Double(budget.amount)
                let progressPercentage = remainAmount/amount*100
                cell.porgressView.startProgress(to: CGFloat(progressPercentage), duration: 1.5)
                self?.amountArray.removeAll()
            }

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
