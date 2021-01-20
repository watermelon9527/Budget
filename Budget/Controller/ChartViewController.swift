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
    // Firebase
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    // chart data
    var axisFormatDelgate: IAxisValueFormatter?
    var barSum: Double = 0
    var pieSum: Double = 0
    var barDic = [String: Double]()
    var pieDic = [String: Double]()
    var barDayArray: [String] = []
    var barAmountDailyArray: [Double] = []
    var barAmountArray: [Double] = []
    var pieCategoryArray: [String] = []
    var pieAmountDailyArray: [Double] = []
    var pieAmountArray: [Double] = []
    // date
    let date = Date()
    var today: String!
    var day6: String!

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        sevenDayChart()
    }

    func setBackgroundColor() {
        barChartView.backgroundColor = .systemGray6
        pieChartView.backgroundColor = .systemGray6
    }
    func updateBarChartsData() {
        var dataEntries: [BarChartDataEntry] = []
        for iii in 0..<barDayArray.count {
            let dataEntry = BarChartDataEntry(x: Double(iii), y: barAmountArray[iii])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "日期")
        let charData = BarChartData(dataSet: chartDataSet)
        barChartView.data = charData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: barDayArray)
        barChartView.xAxis.granularity = 1

        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInOutBounce)
        chartDataSet.colors = [UIColor(red: 0/255, green: 74/255, blue: 173/255, alpha: 1)]


    }
    func updatePieChartData() {
        let chart = pieChartView!
        var entries = [PieChartDataEntry]()
        for (index, value) in pieAmountArray.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = pieCategoryArray[index]
            entries.append( entry)
        }
        let set = PieChartDataSet( entries: entries, label: "項目佔比")
        let colors1: [UIColor] = [UIColor(red: 147/255, green: 158/255, blue: 174/255,
                                          alpha: 1)
                                  // #4a7fd3 淺藍
                                  ,UIColor(red: 74/255, green: 127/255, blue: 211/255, alpha: 1)
                                  // #939eae 淺灰
                                  ,UIColor(red: 107/255, green: 111/255, blue: 139/255, alpha: 1)
                                  // #6b6f8b 灰紫2
                                  ,UIColor(red: 206/255, green: 166/255, blue: 41/255, alpha: 1)
                                  // #cea629 芥末
                                  ,UIColor(red: 135/255, green: 105/255, blue: 94/255, alpha: 1)
                                  // #87695e 棕色
                                  ,UIColor(red: 103/255, green: 122/255, blue: 113/255, alpha: 1)
                                  // #677a71 深白綠
                                  ,UIColor(red: 147/255, green: 174/255, blue: 161/255, alpha: 1)
                                  // #93aea1 淡綠
                                  ,UIColor(red: 150/255, green: 151/255, blue: 174/255, alpha: 1)
                                  // #9697ae 淡紫
        ]
        set.colors = colors1
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        chart.isUserInteractionEnabled = false

        let description = Description()
        //        description.text = "項目佔比"
        chart.chartDescription = description
        //        chart.centerText = "Pie Chart"
        chart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInCirc)
        chart.holeRadiusPercent = 0.3
        chart.transparentCircleColor = UIColor.clear
    }
    func sevenDayChart() {
        pieCategoryArray.removeAll()
        pieAmountArray.removeAll()
        barDayArray.removeAll()
        barAmountArray.removeAll()

        let date = Date()
        let today = dateToString(date, dateFormat: "yyyy/MM/dd")
        let sevenToday = dateToString(date, dateFormat: "MM/dd")
        barDayArray.append(sevenToday)

        let dateminus1 = Date.yesterday
        let day1 = dateToString(dateminus1, dateFormat: "yyyy/MM/dd")
        let sevenOne = dateToString(dateminus1, dateFormat: "MM/dd")
        barDayArray.append(sevenOne)

        let dateminus2 = dateminus1.dayBefore
        let day2 = dateToString(dateminus2, dateFormat: "yyyy/MM/dd")
        let sevenTwo = dateToString(dateminus2, dateFormat: "MM/dd")

        barDayArray.append(sevenTwo)

        let dateminus3 = dateminus2.dayBefore
        let day3 = dateToString(dateminus3, dateFormat: "yyyy/MM/dd")
        let sevenThree = dateToString(dateminus3, dateFormat: "MM/dd")
        barDayArray.append(sevenThree)

        let dateminus4 = dateminus3.dayBefore
        let day4 = dateToString(dateminus4, dateFormat: "yyyy/MM/dd")
        let sevenFour = dateToString(dateminus4, dateFormat: "MM/dd")
        barDayArray.append(sevenFour)

        let dateminus5 = dateminus4.dayBefore
        let day5 = dateToString(dateminus5, dateFormat: "yyyy/MM/dd")
        let sevenFive = dateToString(dateminus5, dateFormat: "MM/dd")
        barDayArray.append(sevenFive)

        let dateminus6 = dateminus5.dayBefore
        let day6 = dateToString(dateminus6, dateFormat: "yyyy/MM/dd")
        let sevenSix = dateToString(dateminus6, dateFormat: "MM/dd")
        barDayArray.append(sevenSix)

        barDic[today] = 0
        barDic[day1] = 0
        barDic[day2] = 0
        barDic[day3] = 0
        barDic[day4] = 0
        barDic[day5] = 0
        barDic[day6] = 0
        pieDic["食物"] = 0
        pieDic["飲品"] = 0
        pieDic["娛樂"] = 0
        pieDic["交通"] = 0
        pieDic["消費"] = 0
        pieDic["家用"] = 0
        pieDic["醫藥"] = 0
        pieDic["其他"] = 0

        barDayArray.reverse()
        FirestoreManger.shared.loadPieAmount(today: today, day6: day6)
        self.updatePieChartData()
        //        FirestoreManger.shared.loadBarAmount(today: today, day6: day6)
        //        self.updateBarChartsData()

              loadBarAmount(today: today, day6: day6)
               loadPieAmount(today: today, day6: day6)


    }
    func loadBarAmount(today: String, day6: String) {
        db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isGreaterThanOrEqualTo: day6 )
            .whereField("date", isLessThanOrEqualTo: today )
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    _ = [BartAmount]()
                    for document in snapshot!.documents {
                        do {
                            if let dayrecord = try document.data(as: BartAmount.self, decoder: Firestore.Decoder()) {
                                let date1 = dayrecord.date
                                self.barAmountDailyArray = []
                                self.barSum = 0
                                let data = document.data()
                                let amount = data["amount"] as? Int ?? 0
                                let category = data["category"] as? String ?? ""
                                let timeStamp = data["timeStamp"] as? String ?? ""
                                let date = data["date"] as? String ?? ""
                                let comments = data["comments"] as? String ?? ""
                                let documentID = data["documentID"] as? String ?? ""
                                let record = BartAmount(amount: amount, category: category,
                                               timeStamp: timeStamp, date: date, comments: comments, documentID: documentID)
                                print(record)
                                let doubleAmount = Double(amount)
                                self.barAmountDailyArray.append(doubleAmount)
                                self.barSum = self.barAmountDailyArray.reduce(0, +)
                                self.barDic[date1]? += self.barSum
                                print(self.barDic[date1] ?? ["bad": 123])
                            }
                        } catch {
                            print("decode catch")                        }
                    }
                    let sortDic = self.barDic.sorted { firstDictionary, secondDictionary in
                        return firstDictionary.0 < secondDictionary.0 
                    }
                    for (_, value) in sortDic {
                        self.barAmountArray.append(Double(value))
                    }
                    print(sortDic)
                    self.updateBarChartsData()
                }
            }
    }
    func loadPieAmount(today: String, day6: String) {
        db.collection("User").document("\(userID ?? "user1")").collection("record")
            .whereField("date", isGreaterThanOrEqualTo: day6 )
            .whereField("date", isLessThanOrEqualTo: today )
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    _ = [BartAmount]()
                    for document in snapshot!.documents {
                        do {
                            if let dayrecord = try document.data(as: BartAmount.self, decoder: Firestore.Decoder()) {
                                let category1 = dayrecord.category
                                self.pieAmountDailyArray = []
                                self.pieSum = 0
                                let data = document.data()
                                let amount = data["amount"] as? Int ?? 0
                                let category = data["category"] as? String ?? ""
                                let timeStamp = data["timeStamp"] as? String ?? ""
                                let date = data["date"] as? String ?? ""
                                let comments = data["comments"] as? String ?? ""
                                let documentID = data["documentID"] as? String ?? ""
                                _ = BartAmount(amount: amount, category: category, timeStamp: timeStamp,
                                               date: date, comments: comments, documentID: documentID)
                                let doubleAmount = Double(amount)
                                self.pieAmountDailyArray.append(doubleAmount)
                                self.pieSum = self.pieAmountDailyArray.reduce(0, +)
                                self.pieDic[category1]? += self.pieSum
                            }
                        } catch {
                            print("decode catch")                        }
                    }
                    for (key, value) in self.pieDic  where  value != 0 {
                        self.pieCategoryArray.append(key)
                        self.pieAmountArray.append(Double(value))
                    }
                    self.updatePieChartData()
                }
            }
    }
    func dateToString(_ date: Date, dateFormat: String = "MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    func getToday() {
        let timeStamp = date.timeIntervalSince1970
        let timeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.dateFormat = "MM/dd"
        today = dateFormatter.string(from: date)
    }
}
