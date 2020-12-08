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
    var timeStamp: Date
    var comments: String
    var dictionary: [String: Any] {
        return [
            "amount": amount,
            "category": category,
            "timestamp": timeStamp,
            "comments": comments
        ]
    }
}
protocol DocumentSerializeable {
    init?(dictionary: [String:Any])
}

extension Record: DocumentSerializeable {
    init?(dictionary: [String:Any]) {
        guard let amount = dictionary["name"] as? Int,
              let category = dictionary["content"] as? String,
              let timeStamp = dictionary["timeStamp"] as? Date,
              let comments = dictionary["comments"] as? String
        else {return nil}

        self.init(amount: amount, category: category, timeStamp: timeStamp, comments: comments)
    }
}
