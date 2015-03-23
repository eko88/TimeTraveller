//
//  ViewController.swift
//  TimeTraveller
//
//  Created by yasha walker on 3/23/15.
//  Copyright (c) 2015 yasha walker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var percent: UILabel!
    
    @IBAction func timeSliderChanged(sender: UISlider) {
        
        var currentValue = slider.value * 100
        
        percent.text = "\(currentValue)"
        
        doMath( slider.value )
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHTML()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    func getHTML() -> NSData
    {
        let myURLString = "http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=xml&titles=1077"
        let myURL = NSURL(string: myURLString)
        
        var error: NSError?
        let myHTMLString = NSString(contentsOfURL: myURL!, encoding: NSUTF8StringEncoding, error: &error)
        
        //println("HTML : \(myHTMLString)")
        var newString = String(myHTMLString!).stringByReplacingOccurrencesOfString("&lt;", withString: "<", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        newString = newString.stringByReplacingOccurrencesOfString("&gt;", withString: ">", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var data : NSData = newString.dataUsingEncoding(NSUTF8StringEncoding)!
        
        return data
    }
    
    func parseHTML( data : NSData )
    {
        
        let tutorialsParser = TFHpple(HTMLData: data )
        let tutorialsXPathString = "/html/body/ul/li"
        if let tutorialNodes = tutorialsParser.searchWithXPathQuery(tutorialsXPathString) as? [TFHppleElement] {
            for element in tutorialNodes {
                let content = element.firstChild.content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let identifier = element.attributes["id"] as String
                println("id = \(identifier); content = \(content)")
                
                if let ul = element.childrenWithTagName("ul") as? [TFHppleElement] {
                    if let li = ul.first?.childrenWithTagName("li") as? [TFHppleElement] {
                        for element in li {
                            let content = element.firstChild.content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                            let identifier = element.attributes["id"] as String
                            println("  child id = \(identifier); content = \(content)")
                        }
                    }
                }
            }
        }
        
        
    }
    
    func doMath( sliderValue:Float )
    {
        
        let getdate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear, fromDate: getdate)
        let year = components.year
        
        var percentage = pow(sliderValue, 3.0)
        
        let a:Int = year
        let b:Int = Int(exp((20.3444 * percentage) + 3) - exp(3.0))
        
        var T = a - b
        date.text = "\(T)"
        
    }
}

