//
//  ViewController.swift
//  KisanHub
//
//  Created by akshay bansal on 12/3/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

import UIKit
import MessageUI


class ViewController: UIViewController,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate {
    
    let countries = ["UK","England","Scotland","Wales"]
    let wheathers = ["Tmax","Tmin","Tmean","Sunshine","Rainfall"]

    let networkmanager = NetworkManager()
    
    let LoadingView : UIView = {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.alpha = 0.6
        view.backgroundColor = UIColor.black
        let activityindicator  = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityindicator.center = view.center
        view.addSubview(activityindicator)
        activityindicator.startAnimating()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func downloadButton(_ sender: Any) {
        
        let coreFuncs = CoreFunctionalities()
        coreFuncs.deleteAllRecords()
        startactivityIndicator()
        startDownloading()
        
    }
    

    func startDownloading() {
        
        for country in countries {
            for wheather in wheathers
            {
                remaingParsingOperations = remaingParsingOperations + 1
                networkmanager.downloadData(county: country, wheather: wheather, completion:parseData)
            }
        }
    }
    
    func startactivityIndicator() {
        self.view.addSubview(LoadingView)
    }
    
    func stopActivityIndicator(){
        DispatchQueue.main.async {
            self.LoadingView.removeFromSuperview()
        }
      
    }
    
    /*--Parsing data Start--*/
    var remaingParsingOperations = 0
    lazy var parsingQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "data parsing queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

 
    func parseData(data : String)
    {
        let Dp = DataParser(data: data)
        Dp.completionBlock = { [unowned self] in
            self.remaingParsingOperations =  self.remaingParsingOperations - 1
            if self.remaingParsingOperations == 0 {
                 self.stopActivityIndicator()
            }
            
        }

        parsingQueue.addOperation(Dp)

        
    }

    /*--Parsing data end--*/
    
    
    
    /*--Dumping and Sharing of csv--*/
    
    @IBAction func shareCsv(_ sender: Any) {
        exportToCSV()
        eMailCSV()
    }
    
    
    
    func exportToCSV() {
        
        var results: [WheatherStatistics] = []
        do {
            results = try context.fetch(WheatherStatistics.fetchRequest())
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
        
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let exportFilePath = documentDirectoryPath + "/weather.csv"
        let exportFileURL = URL(fileURLWithPath: exportFilePath)
        if(FileManager.default.fileExists(atPath: exportFilePath) ){
            do {
                try FileManager.default.removeItem(atPath: exportFilePath)
            }
            catch let error as NSError {
                print(" File not able to delete \(error.localizedDescription)")
            }
            
        }
        else{
        FileManager.default.createFile(atPath: exportFilePath,
                                       contents: Data(), attributes: nil)
        
        }
        var csvText = "country,Wheather,year,key,value\n"
        
        for result in results {
            let keyValues  : Set<KeyValue> = result.values as! Set<KeyValue>
            for keyValue : KeyValue in keyValues{
                let newLine = "\(result.country ?? "N/A"),\(result.wheather ?? "N/A"),\(keyValue.year ?? "N/A"),\(keyValue.key ?? "N/A"),\(keyValue.value ?? "N/A")\n"
                csvText.append(newLine)
            }
        }
        
        do {
            try csvText.write(to: exportFileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        print(path)
    }
    
    
    
    func eMailCSV() -> Void {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let FilePath = documentDirectoryPath + "/weather.csv"
        let fileURL = URL(fileURLWithPath: FilePath)
        
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        // Set preset information included in the email
        mailComposerVC.setSubject("Wheather Statics Data")
        mailComposerVC.setMessageBody("Hi, \n Please find the attached csv file for the wheather statical data.", isHTML: false)
        
        do{
            try mailComposerVC.addAttachmentData(Data.init(contentsOf: fileURL), mimeType:  "text/csv", fileName: "weather.csv")
        }
        catch{
            print(error.localizedDescription)
        }
        
        // Check if MfComposer is functioning properly.
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposerVC, animated: true, completion: nil)
        }
        else
        {
            print("Not able to send email")
            
        }
    }
    /*--End of Dumping and Sharing of csv--*/
    
    /*---MfmalViewController delegates-*/
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
 

}


