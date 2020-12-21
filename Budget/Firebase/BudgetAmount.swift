//
//  BudgetAmount.swift
//  Budget
//
//  Created by nono chan  on 2020/12/21.
//

import Foundation
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
struct BudgetAmount: Codable {
    var amount: Int
    var dictionary: [String: Any] {
        return [
            "amount": amount
        ]
}
}
protocol DocumentSerializeable2 {
    init?(dictionary: [String: Any])
}
extension BudgetAmount: DocumentSerializeable2 {
    init?(dictionary: [String: Any]) {
        guard let amount = dictionary["name"] as? Int
//              let category = dictionary["content"] as? String,
//              let timeStamp = dictionary["timeStamp"] as? String,
//              let period = dictionary["period"] as? String,
//              let date = dictionary["date"] as? String
        else {return nil}

        self.init(amount: amount)
    }
}
