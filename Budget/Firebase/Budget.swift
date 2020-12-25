//
//  Budget.swift
//  Budget
//
//  Created by nono chan  on 2020/12/18.
//

import Foundation
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
struct Budget: Codable {
    var amount: Int
    var category: String
    var timeStamp: String
    var date: String
    var period: String
    var documentID: String
    var dictionary: [String: Any] {
        return [
            "amount": amount,
            "category": category,
            "timestamp": timeStamp,
            "period": period,
            "date": date,
            "documentID": documentID
        ]
    }
}
protocol DocumentSerializeable1 {
    init?(dictionary: [String: Any])
}
extension Budget: DocumentSerializeable1 {
    init?(dictionary: [String: Any]) {
        guard let amount = dictionary["name"] as? Int,
              let category = dictionary["content"] as? String,
              let timeStamp = dictionary["timeStamp"] as? String,
              let period = dictionary["period"] as? String,
              let date = dictionary["date"] as? String,
              let documentID = dictionary["documentID"] as? String
        else {return nil}
        self.init(amount: amount, category: category, timeStamp: timeStamp, date: date, period: period, documentID: documentID)
    }
}
