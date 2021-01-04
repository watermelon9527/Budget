//
//  BudgetTests.swift
//  BudgetTests
//
//  Created by nono chan  on 2020/12/31.
//

import XCTest
@testable import Budget
class BudgetTests: XCTestCase {
    var array = [String]()
    let firstday: String = "2020/12/22"
    var correctArray = ["12/22", "12/23", "12/24", "12/25", "12/26", "12/27", "12/28"]
    var errorArray = ["12/22", "12/23", "12/24", "12/25", "12/26", "12/27", "12/27"]
    func dateStringToDate(_ dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let date = dateFormatter.date(from: dateStr)
        return date ?? Date()
    }
    func dateToString(_ date: Date, dateFormat: String = "MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var date = dateStringToDate(firstday)

        for _ in 1...7 {
            let dayString = dateToString(date, dateFormat: "MM/dd")
            array.append(dayString)
            date = date.dayAfter
        }
        XCTAssertEqual(array, correctArray)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
