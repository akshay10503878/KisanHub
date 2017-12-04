//
//  charts.swift
//  KisanHub
//
//  Created by akshay bansal on 12/5/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

import Foundation
import SwiftChart
import CoreData

class CustomScrollView: UIScrollView,ChartDelegate{
    

    let wheathers = ["Minimum Temperature","Rainfall","Sunshine","Mean Temperature","Maximum Temperature"]

    
    @IBOutlet var chartView1: Chart!
    @IBOutlet var chart1SelectedVal: UILabel!
    @IBOutlet var chartView2: Chart!
    @IBOutlet var chart2SelectedVal: UILabel!
    @IBOutlet var chartView3: Chart!
    @IBOutlet var chart3SelectedVal: UILabel!
    
    let monthsDict : [String : Int] = ["JAN" : 0,"FEB" : 1, "MAR" : 2, "APR" : 3, "MAY" : 4, "JUN" : 5, "JUL" : 6, "AUG" : 7, "SEP" : 8, "OCT" : 9, "NOV" : 10, "DEC" : 11, "WIN" : 12, "SPR" : 13, "SUM" : 14, "AUT" : 15, "ANN" : 16]
    
    /*--configurimg chart start--*/
    
    func configureCharts() {
        
        /*--Fetch data From Core Data--*/
        var results: [WheatherStatistics] = []
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WheatherStatistics")
            
            results = try context.fetch(fetchRequest) as! [WheatherStatistics]
            
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
        
        if results.count == 0 {
            return
        }
        
        
        configureChart1(results: results)
        configureChart2(results: results)
        configureChart3(results: results)
    }
    
    
    func configureChart1( results : [WheatherStatistics]) {
        
        chartView1.removeAllSeries()
        
        var results = results
        
        /*--filterig with respect to data--*/
        results = results.filter({ (obj) -> Bool in
            obj.wheather == "Sunshine" ? true : false
        })
        
        results = results.sorted(by: { (a, b) -> Bool in
            return a.country! >=  b.country! ?  true : false
        })
        
        var labelsAsString: Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC","WIN", "SPR", "SUM", "AUT", "ANN"]
        chartView1.xLabelsFormatter = { (labelIndex: Int, labelValue: Float) -> String in
            return labelsAsString[labelIndex]
        }
        
        
        
        var chartSeriesArray = [ChartSeries]()

        for result in results {
            
            let keyValues  : Set<KeyValue> = (result.values as! Set<KeyValue>).filter({ (data) -> Bool in
                data.year == "2000" ? true : false
            })
            
            let sortedKeyValues = (keyValues.sorted(by: { (a, b) -> Bool in
                let val1 = monthsDict[a.key!] ?? 0
                let val2 = monthsDict[b.key!] ?? 0
                return val1 < val2
            }))
            
            
            var array = [Float]()
            for keyValue : KeyValue in sortedKeyValues{
                
                if keyValue.value == "N/A"{
                    array.append(0.0)
                }
                else
                {
                    array.append(Float(keyValue.value ?? "0") ?? 0.0)
                }
            }
            let series = ChartSeries(array)
            series.color = getRandomColor()
            chartSeriesArray.append(series)
            
        }
        
        chartView1.add(chartSeriesArray)
        chartView1.delegate = self
    }
    
    
    func configureChart2(results : [WheatherStatistics]) {
        
        chartView2.removeAllSeries()
        var results = results
        
        results = results.filter({ (obj) -> Bool in
            obj.country == "Wales" ? true : false
        })
        
        results = results.sorted(by: { (a, b) -> Bool in
            if a.wheather != nil, b.wheather != nil{
                return   a.wheather! <=  b.wheather! ? true : false
            }
            return false
        })
        
        
        chartView2.delegate = self
        
        var labelsAsString: Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC","WIN", "SPR", "SUM", "AUT", "ANN"]
        chartView2.xLabelsFormatter = { (labelIndex: Int, labelValue: Float) -> String in
            return labelsAsString[labelIndex]
        }
        
        
        var chartSeriesArray = [ChartSeries]()
        
        for result in results {
            print(result.wheather!)
            print(result.country!)
            
            let keyValues  : Set<KeyValue> = (result.values as! Set<KeyValue>).filter({ (data) -> Bool in
                data.year == "2000" ? true : false
            })
            
            let sortedKeyValues = (keyValues.sorted(by: { (a, b) -> Bool in
                let val1 = monthsDict[a.key!] ?? 0
                let val2 = monthsDict[b.key!] ?? 0
                return val1 < val2
            }))
            
            var array = [Float]()
            for keyValue : KeyValue in sortedKeyValues{
                
                if keyValue.value == "N/A"{
                    array.append(0.0)
                }
                else
                {
                    array.append(Float(keyValue.value ?? "0") ?? 0.0)
                }
            }
            let series = ChartSeries(array)
            series.color = getRandomColor()
            series.area = true
            chartSeriesArray.append(series)
        }
        
        chartView2.add(chartSeriesArray)
    }
    
    
    
    func configureChart3( results : [WheatherStatistics]) {
        
        chartView3.removeAllSeries()
        
        var results = results
        
        /*--filterig with respect to data--*/
        results = results.filter({ (obj) -> Bool in
            obj.wheather == "Sunshine" ? true : false
        })
        
        results = results.filter({ (obj) -> Bool in
            obj.country == "Wales" ? true : false
        })
        
        var labelsAsString: Array = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC","WIN", "SPR", "SUM", "AUT", "ANN"]
        chartView1.xLabelsFormatter = { (labelIndex: Int, labelValue: Float) -> String in
            return labelsAsString[labelIndex]
        }
        
        var chartSeriesArray = [ChartSeries]()
        
        for result in results {
            
            let keyValues  : Set<KeyValue> = (result.values as! Set<KeyValue>)
            
            var sortedKeyValues = (keyValues.sorted(by: { (a, b) -> Bool in
                let val1 = monthsDict[a.key!] ?? 0
                let val2 = monthsDict[b.key!] ?? 0
                return val1 < val2
            }))
            
            sortedKeyValues = (keyValues.sorted(by: { (a, b) -> Bool in
                let val1 = Int(a.year ?? "0") ?? 0
                let val2 = Int(b.year ?? "0") ?? 0
                return val1 < val2
            }))
            
            var array = [Float]()
            for keyValue : KeyValue in sortedKeyValues{
                
                if keyValue.value == "N/A"{
                    array.append(0.0)
                }
                else
                {
                    array.append(Float(keyValue.value ?? "0") ?? 0.0)
                }
            }
            let series = ChartSeries(array)
            series.color = getRandomColor()
            chartSeriesArray.append(series)
            
        }
        
        chartView3.add(chartSeriesArray)
        chartView3.delegate = self
    }
    
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())/CGFloat(UInt32.max)
        
        let randomGreen:CGFloat = CGFloat(drand48())/1.23
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    // Chart delegate
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        
        var text = ""
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            
                switch chart {
                case chartView1:
                    text = text + "County : \(countries[seriesIndex]) value : \(value) "
                    break
                case chartView2:
                   text = text + "wheather : \(wheathers[seriesIndex]) value : \(value) "
                    break
                case chartView3:
                    text = text + "Year : \(left) value : \(value) "
                    break
                default:
                    self.chart1SelectedVal.text = text
                    self.chart2SelectedVal.text = text
                    self.chart3SelectedVal.text = text
                }
                
            }
        }
        switch chart {
        case chartView1:
            self.chart1SelectedVal.text = text
            break
        case chartView2:
            self.chart2SelectedVal.text = text
            break
        case chartView3:
            self.chart3SelectedVal.text = text
            break
        default:
            self.chart1SelectedVal.text = text
            self.chart2SelectedVal.text = text
            self.chart3SelectedVal.text = text
        }
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }

    
    
    
    
}

