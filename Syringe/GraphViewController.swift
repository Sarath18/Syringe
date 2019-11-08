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
    
    //var curr_value:GraphValue=Null;
    
    let labelDict = [
        "HGB": "Haemoglobin",
        "RBC": "Red Blood Cells",
        "WBC": "White Blood Cells",
        "PLT": "Platelets",
        "NEU": "Neutrophils",
        "BAS": "Basophils",
        "LYM": "Lymphocytes",
        "MON": "Monocyte"
    ]
    
    @IBOutlet weak var analyticsLabel: UILabel!
    var upper_limit: Double = 0;
    var lower_limit: Double = 0;
    
    var reportDate:String="";
    let Rval:Double=0;
    let defaults = UserDefaults.standard;
    var ylabel:String = "";
    var xlabel:String = "date";
    var graphData:[GraphValue]=[];
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataLabelDescription: UILabel!
    
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
    
    func inLimit(tt: Double) -> Bool {
        if tt>lower_limit && tt<upper_limit{
            return true
        }
        return false
    }
    
    func analytics(){
        var rr:Array<Double> = []
        
        for i in self.graphData{
            rr.append(i.yvalue)
        }
        
        if inLimit(tt: rr[0]) && inLimit(tt:rr[1]) && inLimit(tt:rr[1]) {
            if rr[0]<rr[1] && rr[1]<rr[2] {
                analyticsLabel.text = "All the values for your \(ylabel) are inside safe range. \nThe value for \(ylabel) has increased over the last few reports so consider trying to bring it under control ";
                
            }
            else if rr[0]>rr[1] && rr[1]>rr[2]{
                analyticsLabel.text = "All the values for your \(ylabel) are inside safe range. \nThe value for \(ylabel) has been fluctuation.\nConsider sticking to your dietary plan ";
            }
            else if rr[0]>rr[1] && rr[1]<rr[2] {
                analyticsLabel.text = "All the values for your \(ylabel) are inside safe range.\nThe value for \(ylabel) for the second report shows a fluctuation over the the first and third indicating improper medication intake.\n";
                
                
            }
            else{
                analyticsLabel.text = "All the values for your \(ylabel) are inside safe range.\nThe value for \(ylabel) for the second report shows a rise over the the first and third indicating improper quantity diet and excersive intake.\n";
            }
            
        }
        else if !inLimit(tt: rr[0]) && !inLimit(tt:rr[1]) && !inLimit(tt:rr[1]){
            analyticsLabel.text = "Careful. Your previous records are out of range please consider visiting a doctor";
            analyticsLabel.isHighlighted = true
        }
        else{
            analyticsLabel.text = "Some of the values for your \(ylabel) were out of safe range. \nRemember to get your regular checkup.";
        }
        
    }
    
    
    func setChartValues(){
        
        var cnt1:Int = 0;
        var ind:Int = -1;
        
        for i in self.graphData{
            
            if i.xvalue==self.reportDate{
                ind = cnt1;
            }
            cnt1+=1
        }
        
        analytics();
        
        var values :[ChartDataEntry] = []
        var lower_line :[ChartDataEntry] = []
        var upper_line :[ChartDataEntry] = []
        
        var cnt:Double = 0;
        print(lower_limit)
        print(upper_limit)
        
        for item in graphData{
            values.append(ChartDataEntry(x:cnt, y:item.yvalue));
            upper_line.append(ChartDataEntry(x:cnt, y:upper_limit));
            lower_line.append(ChartDataEntry(x:cnt, y:lower_limit));
            cnt+=1;
        }
        
        let set = LineChartDataSet(entries:values,label: self.ylabel);
        let data = LineChartData(dataSet: set);
        
        let upper_set = LineChartDataSet(entries: upper_line, label: "upper_limit")
        let lower_set = LineChartDataSet(entries: lower_line, label: "lower_limit")
        
        data.addDataSet(upper_set)
        data.addDataSet(lower_set)
        
        
        
        lower_set.circleRadius = 0
        lower_set.circleHoleRadius = 0
        lower_set.lineDashPhase = 0
        lower_set.colors = [NSUIColor(red: 0/255.0, green: 100/255.0, blue: 200/255.0, alpha: 3.0)]
        
        upper_set.circleRadius = 0
        upper_set.circleHoleRadius = 0
        upper_set.colors = [NSUIColor(red: 0/255.0, green: 100/255.0, blue: 200/255.0, alpha: 3.0)]
        
        
        set.highlightColor = NSUIColor.black
        set.highlightLineDashLengths = [15.0, 5.0]
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
        self.lineChartView.leftAxis.enabled = false;
        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        self.lineChartView.xAxis.granularity = 1

        
        let ll = ChartLimitLine(limit: 4.0)
        let ul = ChartLimitLine(limit: 7.0)
        
        self.lineChartView.rightAxis.addLimitLine(ll)
        self.lineChartView.rightAxis.addLimitLine(ul)
        print(self.lineChartView.rightAxis.isDrawLimitLinesBehindDataEnabled)
        
        self.lineChartView.legend.enabled = false
        self.lineChartView.leftAxis.gridColor = UIColor(red:220/255, green:220/255,blue:220/255,alpha:1)
        self.lineChartView.translatesAutoresizingMaskIntoConstraints = false
        self.lineChartView.animate(yAxisDuration: 0.3)
        self.lineChartView.highlightValue(x:Double(ind),y:graphData[ind].yvalue,dataSetIndex: 0, dataIndex: 0)

        

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
            self.dataLabelDescription.text = self.labelDict[self.ylabel]
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
