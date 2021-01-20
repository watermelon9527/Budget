//
//  FirestoreManager.swift
//  Budget
//
//  Created by nono chan  on 2021/1/6.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
class FirestoreManger {

    let userID = Auth.auth().currentUser?.uid
    static let shared = FirestoreManger()
    lazy var db = Firestore.firestore()
    //  Budget
    var sum: Int = 0
    var amountArray = [Int]()
    // Chart
    var barSum: Double = 0
    var pieSum: Double = 0
    var barDic = [String: Double]()
    var pieDic = [String: Double]()
    var barDayArray: [String] = []
    var barAmountDailyArray: [Double] = []
    var barAmountArray: [Double] = []
    var pieCategoryArray: [String] = []
    var pieAmountDailyArray: [Double] = []
    var pieAmountArray: [Double] = []
    // BUdgt function
    func loadBudgetCategory(completion: @escaping ([Budget]) -> Void) { let doc = db.collection("User").document("\(userID ?? "user1")").collection("category")
        doc.getDocuments { snapshot, error in
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
                }
                completion(budgetArray)
            }
        }
    }
    func loadRecordAmount(day1: String, day2: String, category: String, completion: @escaping(Int) -> Void) {
        sum = 0
        amountArray = []
        let doc =  db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isLessThanOrEqualTo: day2)
            .whereField("date", isGreaterThanOrEqualTo: day1 )
            .whereField("category", isEqualTo: category)
        doc.getDocuments { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
//                self.sum = 0
                for document in snapshot!.documents {
                    let data = document.data()
                    let amount = data["amount"] as? Int ?? 0
                    self.amountArray.append(amount)
                    let sum = self.amountArray.reduce(0, +)
                    self.sum = sum
                }
                completion(self.sum)
            }
        }
    }
    // Chart function
    func loadPieAmount(today: String, day6: String) {
        db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isGreaterThanOrEqualTo: day6 )
            .whereField("date", isLessThanOrEqualTo: today )
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    _ = [BartAmount]()
                    for document in snapshot!.documents {
                        do {
                            if let dayrecord = try document.data(as: BartAmount.self, decoder: Firestore.Decoder()) {
                                let category1 = dayrecord.category
                                self.pieAmountDailyArray = []
                                self.pieSum = 0
                                let data = document.data()
                                let amount = data["amount"] as? Int ?? 0
                                let category = data["category"] as? String ?? ""
                                let timeStamp = data["timeStamp"] as? String ?? ""
                                let date = data["date"] as? String ?? ""
                                let comments = data["comments"] as? String ?? ""
                                let documentID = data["documentID"] as? String ?? ""
                                _ = BartAmount(amount: amount, category: category, timeStamp: timeStamp,
                                               date: date, comments: comments, documentID: documentID)
                                let doubleAmount = Double(amount)
                                self.pieAmountDailyArray.append(doubleAmount)
                                self.pieSum = self.pieAmountDailyArray.reduce(0, +)
                                self.pieDic[category1]? += self.pieSum
                            }
                        } catch {
                            print("decode catch")                        }
                    }
                    for (key, value) in self.pieDic  where  value != 0 {
                        self.pieCategoryArray.append(key)
                        self.pieAmountArray.append(Double(value))
                    }
                 //   self.updatePieChartData()
                }
            }
    }
    func loadBarAmount(today: String, day6: String) {
        db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isGreaterThanOrEqualTo: day6 )
            .whereField("date", isLessThanOrEqualTo: today )
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    _ = [BartAmount]()
                    for document in snapshot!.documents {
                        do {
                            if let dayrecord = try document.data(as: BartAmount.self, decoder: Firestore.Decoder()) {
                                let date1 = dayrecord.date
                                self.barAmountDailyArray = []
                                self.barSum = 0
                                let data = document.data()
                                let amount = data["amount"] as? Int ?? 0
                                let category = data["category"] as? String ?? ""
                                let timeStamp = data["timeStamp"] as? String ?? ""
                                let date = data["date"] as? String ?? ""
                                let comments = data["comments"] as? String ?? ""
                                let documentID = data["documentID"] as? String ?? ""
                                let record = BartAmount(amount: amount, category: category,
                                               timeStamp: timeStamp, date: date, comments: comments, documentID: documentID)
                                print(record)
                                let doubleAmount = Double(amount)
                                self.barAmountDailyArray.append(doubleAmount)
                                self.barSum = self.barAmountDailyArray.reduce(0, +)
                                self.barDic[date1]? += self.barSum
                                print(self.barDic[date1] ?? ["bad": 123])
                            }
                        } catch {
                            print("decode catch")                        }
                    }
                    let sortDic = self.barDic.sorted { firstDictionary, secondDictionary in
                        return firstDictionary.0 < secondDictionary.0 // 由小到大排序
                    }
                    for (_, value) in sortDic {
                        self.barAmountArray.append(Double(value))
                    }
                    print(sortDic)
                  //  self.updateBarChartsData()
                }
            }
    }
}
