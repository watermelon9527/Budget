//
//  ChartViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/27.
//

import UIKit
import Charts
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
class ChartViewController: UIViewController {
     var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    var axisFormatDelgate: IAxisValueFormatter?
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var sum: Int = 0

    var barDayArray: [String] = []
    //        let barAmountArray: [Double] = []
    let barAmountArray: [Double] = [ 150, 900, 1000, 2000, 300, 4000, 500]
    //    var pieCategoryArray = [String]()
    let date = Date()
    var today: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        sevenDay()
        updateBarChartsData()
        updatePieChartData()
        barChartView.backgroundColor = .systemGray6
        pieChartView.backgroundColor = .systemGray6
    }
    
    func updateBarChartsData() {
        //生成一個存放資料的陣列，型別是BarChartDataEntry.
        var dataEntries: [BarChartDataEntry] = []

        //實作一個迴圈，來存入每筆顯示的資料內容
        for iii in 0..<barDayArray.count {
            //需設定x, y座標分別需顯示什麼東西
            let dataEntry = BarChartDataEntry(x: Double(iii), y: barAmountArray[iii])
            //最後把每次生成的dataEntry存入到dataEntries當中
            dataEntries.append(dataEntry)
        }
        //透過BarChartDataSet設定我們要顯示的資料為何，以及圖表下方的label
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "日期")
        //把整個dataset轉換成可以顯示的BarChartData
        let charData = BarChartData(dataSet: chartDataSet)
        //最後在指定剛剛連結的myView要顯示的資料為charData
        barChartView.data = charData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: barDayArray)
        barChartView.xAxis.granularity = 1

        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)

        let limit = ChartLimitLine(limit: 800, label: "Budget $800")
        limit.lineColor = .black
        limit.valueTextColor = .black
        barChartView.rightAxis.addLimitLine(limit)
        chartDataSet.colors = [UIColor(red: 0/255, green: 74/255, blue: 173/255, alpha: 1)]

        //            //改變chartDataSet的顏色，此為橘色
        //            chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        //
        //            //改變chartDataSet為彩色
        //            chartDataSet.colors = ChartColorTemplates.colorful()
        //
        //            //標籤換到下方
        //            myView.xAxis.labelPosition = .bottom
        //
        //            //改變barChartView的背景顏色
        //            myView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        //
        //            //一個一個延遲顯現的特效
        //            myView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        //
        //            //彈一下特效
        //            myView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        //
        //            //設立界線
        //            let limit = ChartLimitLine(limit: 10.0, label: "Target")
        //            myView.rightAxis.addLimitLine(limit)
        //
    }
    func updatePieChartData() {
        let pieCategoryArray = ["食物", "飲品", "娛樂", "交通", "消費", "家用", "醫藥", "其他"]
        let pieAmount = [650, 456.13, 78.67, 856.52, 200, 300, 400, 200]
        let chart = pieChartView!
        var entries = [PieChartDataEntry]()
        for (index, value) in pieAmount.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = pieCategoryArray[index]
            entries.append( entry)
        }
        let set = PieChartDataSet( entries: entries, label: "項目佔比")
        let colors1: [UIColor] = [UIColor(red: 147/255, green: 158/255, blue: 174/255,
                                          alpha: 1)
                                  //#4a7fd3 淺藍
                                  ,UIColor(red: 74/255, green: 127/255, blue: 211/255, alpha: 1)
                                  //#939eae 淺灰
                                  ,UIColor(red: 107/255, green: 111/255, blue: 139/255, alpha: 1)
                                  //#6b6f8b 灰紫2
                                  ,UIColor(red: 206/255, green: 166/255, blue: 41/255, alpha: 1)
                                  //#cea629 芥末
                                  ,UIColor(red: 135/255, green: 105/255, blue: 94/255, alpha: 1)
                                  //#87695e 棕色
                                  ,UIColor(red: 103/255, green: 122/255, blue: 113/255, alpha: 1)
                                  //#677a71 深白綠
                                  ,UIColor(red: 147/255, green: 174/255, blue: 161/255, alpha: 1)
                                  //#93aea1 淡綠
                                  ,UIColor(red: 150/255, green: 151/255, blue: 174/255, alpha: 1)
                                  //#9697ae 淡紫
        ]

        set.colors = colors1
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true

        let description = Description()
        //        description.text = "項目佔比"
        chart.chartDescription = description
        //        chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.3
        chart.transparentCircleColor = UIColor.clear
    }

    func loadRecordAmount(day1: String,day2: String) {
        db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isGreaterThanOrEqualTo: day1 )
            .whereField("date", isLessThanOrEqualTo: day2)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        let amount = data["amount"] as? Int ?? 0
                        let category = data["category"] as? String ?? ""
                        //                        self.pieCategoryArray = []
                        //                        self.barAmountArray = []
                        //                        self.pieCategoryArray.append(category)
                        //                        self.barAmountArray.append(amount)
                        //                        let sum = self.barAmountArray.reduce(0, +)
                        //                        print(sum)
                        //                        self.sum = sum
                    }
                }
            }
    }
    func sevenDay() {
        let date = Date()
        let today = date2String(date, dateFormat: "MM-dd")
        barDayArray.append(today)
        let dateminus1 = Date.yesterday
        let day1 = date2String(dateminus1, dateFormat: "MM-dd")
        barDayArray.append(day1)
        let dateminus2 = dateminus1.dayBefore
        let day2 = date2String(dateminus2, dateFormat: "MM-dd")
        barDayArray.append(day2)
        let dateminus3 = dateminus2.dayBefore
        let day3 = date2String(dateminus3, dateFormat: "MM-dd")
        barDayArray.append(day3)
        let dateminus4 = dateminus3.dayBefore
        let day4 = date2String(dateminus4, dateFormat: "MM-dd")
        barDayArray.append(day4)
        let dateminus5 = dateminus4.dayBefore
        let day5 = date2String(dateminus5, dateFormat: "MM-dd")
        barDayArray.append(day5)
        let dateminus6 = dateminus5.dayBefore
        let day6 = date2String(dateminus6, dateFormat: "MM-dd")
        barDayArray.append(day6)
        barDayArray.reverse()
    }
    func date2String(_ date: Date, dateFormat: String = "MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    func getDate() {
        let timeStamp = date.timeIntervalSince1970
        let timeInterval = TimeInterval(timeStamp)

        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM/dd"

        today = dateFormatter.string(from: date)
        //        weekArray.append(today)
    }
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
