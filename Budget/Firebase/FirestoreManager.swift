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

    var sum: Int = 0
    var amountArray = [Int]()

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
//                self.budgetTableView.reloadData()
            }
        }
    }

    func loadRecordAmount(day1: String, day2: String, category: String, completion: @escaping(Int) -> Void) {
        sum = 0
        let doc =  db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isLessThanOrEqualTo: day2)
            .whereField("date", isGreaterThanOrEqualTo: day1 )
            .whereField("category", isEqualTo: category)
        doc.getDocuments { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
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



}


