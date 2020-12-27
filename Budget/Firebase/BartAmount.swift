//
//  BartAmount.swift
//  Budget
//
//  Created by nono chan  on 2020/12/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
struct BartAmount: Codable {
    var amount: Int
    var category: String
    var timeStamp: String
    var date: String
    var comments: String
    var documentID: String
    var dictionary: [String: Any] {
        return [
            "amount": amount,
            "category": category,
            "timestamp": timeStamp,
            "date": date,
            "comments": comments,
            "documentID": documentID
        ]
    }
}
protocol DocumentSerializeable0 {
    init?(dictionary: [String: Any])
}
extension BartAmount: DocumentSerializeable0 {
    init?(dictionary: [String: Any]) {
        guard let amount = dictionary["amount"] as? Int,
              let category = dictionary["category"] as? String,
              let timeStamp = dictionary["timeStamp"] as? String,
              let date = dictionary["date"] as? String,
              let comments = dictionary["comments"] as? String,
              let documentID = dictionary["documentID"] as? String
        else {return nil}

        self.init(amount: amount, category: category, timeStamp: timeStamp, date: date, comments: comments, documentID: documentID)
    }
}
