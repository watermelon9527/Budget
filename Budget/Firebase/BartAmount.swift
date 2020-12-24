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
    var dictionary: [String: Any] {
        return [
            "amount": amount,
            "category": category,
            "timestamp": timeStamp,
            "date": date
        ]
    }
}
protocol DocumentSerializeable0 {
    init?(dictionary: [String: Any])
}
extension BartAmount: DocumentSerializeable0 {
    init?(dictionary: [String: Any]) {
        guard let amount = dictionary["name"] as? Int,
              let category = dictionary["content"] as? String,
              let timeStamp = dictionary["timeStamp"] as? String,
              let date = dictionary["date"] as? String
        else {return nil}

        self.init(amount: amount, category: category, timeStamp: timeStamp, date: date)
    }
}
