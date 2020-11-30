//
//  ChartViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/27.
//

import UIKit
import Charts
class ChartViewController: UIViewController {

    @IBOutlet weak var myView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!

    var monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var temperatureArray: [Double] = [ 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]
    var axisFormatDelgate: IAxisValueFormatter?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateChartsData()
        updateChartData()

    }

    func updateChartData() {

        let chart = pieChartView!
        let track = ["Food", "Drink", "Entertainment", "Traffic"]
        let money = [650, 456.13, 78.67, 856.52]

        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }

        let set = PieChartDataSet( entries: entries, label: "項目佔比")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []

        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true

        let description = Description()
        description.text = "項目佔比"
        chart.chartDescription = description
//        chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.2
        chart.transparentCircleColor = UIColor.clear

    }

    func updateChartsData() {
        //生成一個存放資料的陣列，型別是BarChartDataEntry.
        var dataEntries: [BarChartDataEntry] = []

        //實作一個迴圈，來存入每筆顯示的資料內容
        for iii in 0..<monthArray.count {
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
        myView.data = charData

        myView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthArray)
        myView.xAxis.granularity = 1

        myView.xAxis.labelPosition = .bottom
        chartDataSet.colors = ChartColorTemplates.colorful()
        myView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        myView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)

        let limit = ChartLimitLine(limit: 25, label: "Budget Target")
        myView.rightAxis.addLimitLine(limit)
    }
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
