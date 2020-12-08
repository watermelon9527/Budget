//
//  User.swift
//  Budget
//
//  Created by nono chan  on 2020/12/8.
//

import Foundation
struct User: Codable {
    var id: String
    var monthlyTarget: String
    var name: String
    var record : Record?

    var dictionary: [String: Any] {
        return [
            "id": id,
            "monthlyTarget": monthlyTarget,
            "name": name,
            "record": record?.dictionary
        ]
    }
}
