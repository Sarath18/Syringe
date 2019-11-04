//
//  GraphViewController.swift
//  Syringe
//
//  Created by student on 02/11/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import Charts

struct GraphValue {
    var yvalue:Double;
    var xvalue:String;
}

class GraphViewController: UIViewController{
    
    
    let defaults = UserDefaults.standard;
    var ylabel:String = "";
    var xlabel:String = "date";
    var graphData:[GraphValue]=[];
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.dismiss(animated: true, completion: nil)
        fetchLabelValues()
        // Do any additional setup after loading the view.
    }
    
    func sortByDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let ready = graphData.sorted(by: { dateFormatter.date(from:$0.xvalue)?.compare(dateFormatter.date(from:$1.xvalue)!) == .orderedAscending })
         print(ready)
    }
    
    func setChartValues(){
        var values :[ChartDataEntry] = []
        
        var cnt:Double = 0;
        
        for item in graphData{
            values.append(ChartDataEntry(x:cnt,y:item.yvalue));
            cnt+=1;
        }
        
        let set = LineChartDataSet(entries:values,label: self.ylabel);
        let data = LineChartData(dataSet: set);
        
        set.circleRadius = 5;
        set.circleColors = [NSUIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)]
        set.circleHoleRadius = 0
        set.mode = .cubicBezier
        set.colors = [NSUIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)]
        
        let gradientColors = [UIColor.red.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        set.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set.drawFilledEnabled = true // Draw the Gradient
        
        
        set.drawFilledEnabled = true
        set.lineWidth = 2
    
        
        var dates:[String] = []
        
        for i in graphData {
            dates.append(i.xvalue)
        }
    
        self.lineChartView.data = data;
        self.lineChartView.drawGridBackgroundEnabled = false;
        self.lineChartView.leftAxis.drawAxisLineEnabled = false
        self.lineChartView.leftAxis.drawGridLinesEnabled = false;
        self.lineChartView.leftAxis.gridColor = NSUIColor.clear
        self.lineChartView.xAxis.drawGridLinesEnabled = false;
        self.lineChartView.rightAxis.drawGridLinesEnabled = false;
        self.lineChartView.rightAxis.drawGridLinesEnabled = false;
        self.lineChartView.rightAxis.gridColor = NSUIColor.clear
        self.lineChartView.highlightPerTapEnabled = true
        self.lineChartView.rightAxis.enabled = false;
        self.lineChartView.rightAxis.enabled = false;
        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        self.lineChartView.xAxis.granularity = 1
        self.lineChartView.leftAxis.drawZeroLineEnabled = false
        self.lineChartView.leftAxis.zeroLineWidth = 0
        self.lineChartView.rightAxis.zeroLineWidth = 0
        self.lineChartView.leftAxis.drawTopYLabelEntryEnabled = false
        self.lineChartView.rightAxis.drawTopYLabelEntryEnabled = false
        self.lineChartView.leftAxis.drawAxisLineEnabled = false;
        self.lineChartView.rightAxis.drawAxisLineEnabled = false;
        self.lineChartView.rightAxis.removeAllLimitLines()
        self.lineChartView.leftAxis.removeAllLimitLines()
        self.lineChartView.legend.enabled = false
        self.lineChartView.leftAxis.gridColor = UIColor(red:220/255, green:220/255,blue:220/255,alpha:1)
        self.lineChartView.translatesAutoresizingMaskIntoConstraints = false
        self.lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.4)

    }
    
    
    func fetchLabelValues()
    {
        let userId = defaults.string(forKey: "userId")!;
        let ref = Database.database().reference(withPath: "reports/\(userId)/");
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                let ch = child as! DataSnapshot;
                var xvalue : String = "";
                var yvalue : Double = 0
                for c in ch.children {
                    let snap = c as! DataSnapshot

                    if(snap.key == self.ylabel) {
                        yvalue = (snap.value as! NSString).doubleValue;
                    }
                    if(snap.key == self.xlabel){
                        xvalue = snap.value as! String;
                    }
                }
                self.graphData.append(GraphValue(yvalue: yvalue, xvalue: xvalue));
            }
            print(self.graphData);
            self.sortByDate();
            self.setChartValues();
            self.dataLabel.text = self.ylabel
        })
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
