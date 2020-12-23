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
        //        getDate()
        //        amountArray = []
        //        loadRecordAmount(day1: budget.date, day2: today, category: budget.category) { [ weak self ] (sum) in
        //            cell.remainderAmount.text = "$\(budget.amount-sum)"
        //            let remainAmount = Double(budget.amount-sum)
        //            let amount = Double(budget.amount)
        //            let progressPercentage = remainAmount/amount*100
        //            cell.circleView.startProgress(to: CGFloat(progressPercentage), duration: 1.5)
        //        }
        //        loadRecordAmount(day1: budgetArray, day2: <#T##String#>, category: <#T##String#>, completion: <#T##(Int) -> Void#>)
    }
    override func viewDidAppear(_ animated: Bool) {}
    var budgetArray = [Budget]()
    //        {
    //            didSet {
    //                getDate()
    //                amountArray = []
    //                for budget in budgetArray {
    //                    loadRecordAmount(day1: budget.date, day2: today, category: budget.category) { [weak self] (sum) in
    //                        self?.sum = sum
    //
    //                        let remainAmount = Double(budget.amount-sum)
    //                        let amount = Double(budget.amount)
    //                        let progressPercentage = remainAmount/amount*100
    //
    //                    }
    //                }
    //                self.budgetTableView.reloadData()
    //            }
    //        }

    func loadData() {
        loadBudgetCategory { [weak self] (newRecords) in
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
                    let newRecord = Budget(amount: amount, category: category, timeStamp: timeStamp, date: date, period: period)
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
//                        print(data)
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
}

extension BudgetViewController: UITabBarDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = budgetTableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath) as! BudgetTableViewCell
        let budget = budgetArray[indexPath.row]
        getDate()
        amountArray = []
        loadRecordAmount(day1: budget.date, day2: today, category: budget.category) { [ weak self ] (sum) in
            cell.remainderAmount.text = "$\(budget.amount-sum)"
            let remainAmount = Double(budget.amount-sum)
            let amount = Double(budget.amount)
            let progressPercentage = remainAmount/amount*100
            cell.circleView.startProgress(to: CGFloat(progressPercentage), duration: 1.5)
            self?.amountArray.removeAll()
        }
        
        cell.amountLabel.text = "$\(budget.amount)"
        cell.remainderCategory.text = "剩餘金額"
        cell.categoryLabel.text = "本\(budget.period)\(budget.category)預算"

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
