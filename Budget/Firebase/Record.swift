//
//  Recird.swift
//  Budget
//
//  Created by nono chan  on 2020/12/8.
//

import Foundation
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
struct Record: Codable {
    var amount: String
    var category: String
    var timeStamp: Date
    var commit: String

    var dictionary: [String: Any] {
        return [
            "amount": amount,
            "category": category,
            "timestamp": timeStamp,
            "commit": commit
        ]
    }
}
protocol DocumentSerializeable {
    init?(dictionary: [String:Any])
}

extension Record: DocumentSerializeable {
    init?(dictionary: [String:Any]) {
        guard let amount = dictionary["name"] as? String,
              let category = dictionary["content"] as? String,
              let timeStamp = dictionary["timeStamp"] as? Date,
              let commit = dictionary["commit"] as? String
        else {return nil}

        self.init(amount: amount, category: category, timeStamp: timeStamp, commit: commit)

    }
}
