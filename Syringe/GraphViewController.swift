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
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLabelValues()
        // Do any additional setup after loading the view.
    }
    
    func sortByDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"// yyyy-MM-dd"
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
        
        let set = LineChartDataSet(entries:values,label: "DataSet1");
        let data = LineChartData(dataSet: set);
        
        self.lineChartView.data=data;
        self.lineChartView.drawGridBackgroundEnabled = false;

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
