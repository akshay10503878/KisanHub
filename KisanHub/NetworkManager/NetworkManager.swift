//
//  NetworkManager.swift
//  KisanHub
//
//  Created by akshay bansal on 12/3/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

import UIKit

let baseUrl = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/%@/date/%@.txt"

class NetworkManager: NSObject {


    func downloadData(county:String , wheather:String,completion : @escaping (String)->())  {
        
        guard let requestURL: NSURL = NSURL(string: String(format:baseUrl,wheather,county)) else {
            print("Ambigious Url")
            return
        }
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data,response,error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("file downloaded successfully.")
                guard let dataString = String(data: data!, encoding: .utf8) else{
                    return
                }
                /*--calling Completion block--*/
                completion(dataString)
                
            } else  {
                print("Failed")
            }
        }
        task.resume()

    }
}
