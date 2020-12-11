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
    var amount: Int
    var category: String
    var timeStamp: Timestamp
    var comments: String
    var date: String
    var dictionary: [String: Any] {
        return [
            "amount": amount,
            "category": category,
            "timestamp": timeStamp,
            "comments": comments,
            "date": date
        ]
    }
}
protocol DocumentSerializeable {
    init?(dictionary: [String: Any])
}

extension Record: DocumentSerializeable {
    init?(dictionary: [String: Any]) {
        guard let amount = dictionary["name"] as? Int,
              let category = dictionary["content"] as? String,
              let timeStamp = dictionary["timeStamp"] as? Timestamp,
              let comments = dictionary["comments"] as? String,
              let date = dictionary["date"] as? String
        else {return nil}

        self.init(amount: amount, category: category, timeStamp: timeStamp, comments: comments, date: date)
    }
}
