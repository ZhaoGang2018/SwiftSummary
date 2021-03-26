//
//  ZGChartViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/4/17.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit
import Charts

class ZGChartViewController: XHBaseViewController {
    
    //折线图
    let lineChartView: LineChartView = {
        $0.noDataText = "暂无统计数据" //无数据的时候显示
        $0.chartDescription?.enabled = false //是否显示描述
        $0.scaleXEnabled = false
        $0.scaleYEnabled = false
        
        $0.leftAxis.drawGridLinesEnabled = false //左侧y轴设置，不画线
        $0.rightAxis.drawGridLinesEnabled = false //右侧y轴设置，不画线
        $0.rightAxis.drawAxisLineEnabled = false
        $0.rightAxis.enabled = false
        $0.legend.enabled = true
        
        return $0
        
    }(LineChartView())
    
    // 柱状图
    let barChartView = BarChartView()
    /*
    let barChartView: BarChartView = {
        $0.noDataText = "暂无统计数据" //无数据的时候显示
        $0.chartDescription?.enabled = false //是否显示描述
        $0.scaleXEnabled = false
        $0.scaleYEnabled = false
        $0.leftAxis.drawGridLinesEnabled = false //左侧y轴设置，不画线
        $0.rightAxis.drawGridLinesEnabled = false //右侧y轴设置，不画线
        $0.rightAxis.drawAxisLineEnabled = false
        $0.rightAxis.enabled = false
        $0.legend.enabled = true
        
        return $0
    }(BarChartView())
 */
    
    let xStr = ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:59"]
    let yValues = [9, 3, 5, 7, 6, 8, 4, 5, 8, 13, 1, 2, 3, 4, 5, 6, 7, 8, 2, 3, 4, 6, 1, 6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "绘制图表"
        self.bgImageView?.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        addBarChartView()
        // addLineChartView()
    }
    
    //添加柱状图
    func addBarChartView() {
        barChartView.delegate = self
        barChartView.noDataText = "暂无统计数据" //无数据的时候显示
        barChartView.chartDescription?.enabled = false //是否显示描述
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        barChartView.legend.enabled = false // 不显示左下角的标识
        barChartView.drawValueAboveBarEnabled = true // true:立柱数值文字显示在外部；false:立柱数值文字显示在内部
        
        //x轴样式
        let xAxis = barChartView.xAxis
        xAxis.granularity = 1.0
        xAxis.valueFormatter = self
        
        xAxis.labelPosition = .bottom //x轴的位置
        xAxis.labelFont = UIFont.Medium(8)
        xAxis.labelTextColor = UIColor.fromHex("#818592")
        xAxis.axisLineColor = UIColor.fromHex("#D1D5E1") // x轴的线的颜色
        xAxis.axisLineWidth = 0.5 // x轴的线的宽度
        
        // x轴网格线
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineWidth = 0.5
        xAxis.gridColor = UIColor.fromHex("#DCE2F4")
        xAxis.gridLineDashLengths = [4, 2]
        
        xAxis.setLabelCount(9, force: true) // x轴显示的最大标签数
        
        // 左侧y轴样式
        let yAxis = barChartView.leftAxis
        // 轴线的颜色字体
        yAxis.labelTextColor = UIColor.fromHex("#3E3F42")
        yAxis.labelFont = UIFont.Semibold(10)
        yAxis.axisLineColor = UIColor.fromHex("#DCDEE3") // y轴的线的颜色
        yAxis.axisLineWidth = 0.5 // y轴的线的宽度
        
        // y轴网格线
        yAxis.drawGridLinesEnabled = true
        yAxis.gridLineWidth = 0.5
        yAxis.gridColor = UIColor.fromHex("#DCE2F4")
        yAxis.gridLineDashLengths = [4, 2] // 网格虚线的间隔
        
        yAxis.setLabelCount(3, force: true) // y轴显示的标签数
        yAxis.axisMaximum = 20 // y轴的最大值
        yAxis.axisMinimum = 0 // y轴的最小值
        
        // 右侧y轴
        barChartView.rightAxis.drawGridLinesEnabled = false //右侧y轴设置，不画线
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.enabled = false
        
        barChartView.frame = CGRect(x: 0, y: SpeedyApp.statusBarAndNavigationBarHeight + 50, width: SpeedyApp.screenWidth, height: 102)
        self.view.addSubview(barChartView)
        setBarChartViewData(xStr: xStr, yValues: yValues)
    }
    
    //配置柱状图
    func setBarChartViewData(xStr: [String], yValues: [Int]) {
        
        let xFormatter = IndexAxisValueFormatter()
        xFormatter.values = xStr
        
        var dataEntris: [BarChartDataEntry] = []
        for (idx, _) in xStr.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(idx), y: Double(yValues[idx]))
            dataEntris.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntris, label: "")
        let color = UIColor.fromHex("#64BCFE") // 每个柱形的颜色
        chartDataSet.colors = [color]
        let chartData = BarChartData(dataSet: chartDataSet)
        
        // 柱形图上面文字的属性
        chartData.setValueFont(UIFont(name: "DIN Condensed", size: 13) ?? UIFont.regular(10))
        chartData.setValueTextColor(UIColor.fromHex("#5B5C65"))
        chartData.setValueFormatter(self)
        chartData.barWidth = 0.7 // 设置柱子宽度为刻度区域的70%
        
        self.barChartView.data = chartData
        self.barChartView.animate(yAxisDuration: 0.4)
    }
}

//注意：这里是签订一个类似于x轴样式的代理，显示需要的自定义字符串
// MARK: - IAxisValueFormatter,设置x轴文字的显示
extension ZGChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let result = xStr[Int(value) % xStr.count]
        return result
    }
}

// MARK: - IValueFormatter,设置柱形图顶部文字的显示
extension ZGChartViewController: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        let newValue = Int(value)
        return "\(newValue)"
    }
}

// MARK: - ChartViewDelegate
extension ZGChartViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        //将选中的数据点的颜色改成黄色
        let chartDataSet: BarChartDataSet? = chartView.data?.dataSets[0] as? BarChartDataSet
        let values = chartDataSet?.entries
        let index = values?.firstIndex(where: {$0.x == highlight.x})  //获取索引
        XHLogDebug("点击index[\(String(describing: index))]")
    }
}


















extension ZGChartViewController {
    
    //添加折线图
    func addLineChartView() {
        lineChartView.frame = CGRect(x: 0, y: SpeedyApp.statusBarAndNavigationBarHeight + 260, width: 200, height: 200)
        lineChartView.center.x = self.view.center.x
        self.view.addSubview(lineChartView)
        setLineChartViewData(xStr, yValues)
    }
    
    //配置折线图
    func setLineChartViewData(_ dataPoints: [String], _ values: [Int]) {
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom //x轴的位置
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.valueFormatter = self
        
        var dataEntris: [ChartDataEntry] = []
        for (idx, _) in dataPoints.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(idx), y: Double(values[idx]))
            dataEntris.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntris, label: "")
        //外圈
        lineChartDataSet.setCircleColor(UIColor.yellow)
        //内圈
        lineChartDataSet.circleHoleColor = UIColor.red
        //线条显示样式
        lineChartDataSet.colors = [UIColor.gray]
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        //设置x轴样式
        let xFormatter = IndexAxisValueFormatter()
        xFormatter.values = dataPoints
        
        self.lineChartView.animate(xAxisDuration: 0.4)
    }
    
    
}
