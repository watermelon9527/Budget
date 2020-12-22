//
//  ChartViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/27.
//

import UIKit
import Charts
import FirebaseAuth

class ChartViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    let userID = Auth.auth().currentUser?.uid

    var weekArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var temperatureArray: [Double] = [ 20, 21, 22, 23, 24, 25, 26]
    var axisFormatDelgate: IAxisValueFormatter?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateBarChartsData()
        updatePieChartData()
        barChartView.backgroundColor = .systemGray6
        pieChartView.backgroundColor = .systemGray6
    }

    func updatePieChartData() {

        let chart = pieChartView!
        let track1 = ["食物", "飲品", "娛樂", "交通", "消費", "家用", "醫藥", "其他"]
        let money1 = [650, 456.13, 78.67, 856.52, 200, 300, 400, 200]
        var entries = [PieChartDataEntry]()
        
        for (index, value) in money1.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track1[index]
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
    func updateBarChartsData() {
        //生成一個存放資料的陣列，型別是BarChartDataEntry.
        var dataEntries: [BarChartDataEntry] = []

        //實作一個迴圈，來存入每筆顯示的資料內容
        for iii in 0..<weekArray.count {
            //需設定x, y座標分別需顯示什麼東西
            let dataEntry = BarChartDataEntry(x: Double(iii), y: temperatureArray[iii])
            //最後把每次生成的dataEntry存入到dataEntries當中
            dataEntries.append(dataEntry)
        }
        //透過BarChartDataSet設定我們要顯示的資料為何，以及圖表下方的label
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "月份")
        //把整個dataset轉換成可以顯示的BarChartData
        let charData = BarChartData(dataSet: chartDataSet)
        //最後在指定剛剛連結的myView要顯示的資料為charData
        barChartView.data = charData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekArray)
        barChartView.xAxis.granularity = 1

        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)

//        let limit = ChartLimitLine(limit: 25, label: "Budget Target")
//        limit.lineColor = .black
//        limit.valueTextColor = .black
//        barChartView.rightAxis.addLimitLine(limit)
        chartDataSet.colors = [UIColor(red: 29/255, green: 78/255, blue: 143/255, alpha: 1)]

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

}
