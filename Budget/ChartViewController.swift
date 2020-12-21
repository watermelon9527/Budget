//
//  ChartViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/27.
//

import UIKit
import Charts
class ChartViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!

//    var monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
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
        let colors1: [UIColor] = [UIColor(red: 104/255, green: 124/255, blue: 139/255, alpha: 1),
                                  UIColor(red: 73/255, green: 87/255, blue: 93/255, alpha: 1),
                                  UIColor(red: 107/255, green: 111/255, blue: 139/255, alpha: 1),
                                  UIColor(red: 141/255, green: 220/255, blue: 228/255, alpha: 1),
                                  UIColor(red: 104/255, green: 139/255, blue: 116/255, alpha: 1),
                                  UIColor(red: 139/255, green: 133/255, blue: 104/255, alpha: 1),
                                  UIColor(red: 224/255, green: 229/255, blue: 225/255, alpha: 1),
                                  UIColor(red: 139/255, green: 104/255, blue: 126/255, alpha: 1)
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

        let limit = ChartLimitLine(limit: 25, label: "Budget Target")
        limit.lineColor = .black
        limit.valueTextColor = .black
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
