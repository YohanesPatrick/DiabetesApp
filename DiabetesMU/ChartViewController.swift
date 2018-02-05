//
//  WeightViewController.swift
//  DiabetesMU
//
//  Created by Yohanes Patrik Handrianto on 1/29/18.
//  Copyright © 2018 Yohanes Patrik Handrianto. All rights reserved.
//

import Foundation
import UIKit
import Charts
import FirebaseDatabase

class ChartViewController: UIViewController {
    var ref: DatabaseReference!
    var WArray = [Int] ()
    @IBOutlet weak var WeightField: UITextField!
    @IBOutlet weak var weightChart: BarChartView!
    @IBAction func weightBtn(_ sender: Any) {
        ref = Database.database().reference().child("Test")
    
        //push data
        if WeightField.text != ""
        {
            ref.child("User/Bryan/weight").childByAutoId().setValue(
                ["Values": Int(WeightField.text!),
                 "Time": ServerValue.timestamp()])
            WeightField.text = ""
        }
        
        //pull data
        
        ref.child("User/Bryan/weight").queryOrdered(byChild: "Time").observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary ?? [:]
            let values = snapshotValue["Values"] as? Int ?? 0
            self.WArray.append(values)
            print(self.WArray)
           
        })
    }


    
    let day = ["M","T","W","T","F","S","S"]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let bloodValues = [80.0, 99.0, 100.0, 120.0, 100.0, 126.0, 111.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChart(dataPoints: day, values: bloodValues )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        WeightField.resignFirstResponder()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var barDataEntries = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            
            let barDataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            barDataEntries.append(barDataEntry)
            
        }
        
    
        let plotBar = BarChartDataSet(values: barDataEntries, label: "weight")
        
        

        let barChartData = BarChartData()
        barChartData.addDataSet(plotBar)
        
        
        weightChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:day)
        weightChart.xAxis.granularity = 1
        
        if weightChart != nil {
            weightChart.chartDescription?.enabled = false
            weightChart.data = barChartData
        }
    }
    }


 

